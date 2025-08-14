#!/usr/bin/env fish
# Unified project discovery and configuration

# Project discovery paths - single source of truth
set -gx PROJECT_PATHS \
    ~/Projects \
    ~/rad \
    ~/dotfiles \
    ~/Projects/cells \
    ~/Projects/9am-fe \

# Project detection patterns
set -gx PROJECT_MARKERS \
    .git \
    .hg \
    .svn \
    package.json \
    Cargo.toml \
    go.mod \
    pom.xml \
    build.gradle \
    Makefile \
    CMakeLists.txt \
    .project

# Session naming preferences
set -gx SESSION_NAME_TRANSFORM "tr . _ | tr - _"

# Function to discover all projects
function discover_projects --description "Discover all projects based on markers"
    set -l projects

    for path in $PROJECT_PATHS
        if test -d "$path"
            # Find directories containing project markers
            for marker in $PROJECT_MARKERS
                set -l found (find "$path" -maxdepth 3 -name "$marker" -type f -o -name "$marker" -type d 2>/dev/null | xargs -I {} dirname {} | sort -u)
                if test -n "$found"
                    set projects $projects $found
                end
            end

            # Also include direct subdirectories as potential projects
            for dir in "$path"/*
                if test -d "$dir"
                    set projects $projects "$dir"
                end
            end
        end
    end

    # Remove duplicates and sort
    printf '%s\n' $projects | sort -u
end

# Function to get project name from path
function project_name_from_path --description "Extract project name from path"
    set -l path $argv[1]
    basename "$path" | eval $SESSION_NAME_TRANSFORM
end

# Function to find project by name
function find_project_by_name --description "Find project path by name"
    set -l name $argv[1]
    for project in (discover_projects)
        if test (project_name_from_path "$project") = "$name"
            echo "$project"
            return 0
        end
    end
    return 1
end

# Function to select project interactively
function select_project --description "Select project with fzf"
    set -l prompt "Select project"
    if test (count $argv) -gt 0
        set prompt $argv[1]
    end

    discover_projects | \
        fzf --reverse \
            --header "$prompt" \
            --preview 'ls -la {} | head -20' \
            --preview-window=right:40%
end

# Function to get current project (if in one)
function current_project --description "Get current project path if in a project directory"
    set -l current_dir (pwd)

    # Check if current directory is a project
    for marker in $PROJECT_MARKERS
        if test -e "$current_dir/$marker"
            echo "$current_dir"
            return 0
        end
    end

    # Check parent directories up to home
    set -l check_dir "$current_dir"
    while test "$check_dir" != "$HOME" -a "$check_dir" != "/"
        for marker in $PROJECT_MARKERS
            if test -e "$check_dir/$marker"
                echo "$check_dir"
                return 0
            end
        end
        set check_dir (dirname "$check_dir")
    end

    return 1
end

# Function to get project info
function project_info --description "Get information about a project"
    set -l project_path $argv[1]
    if test -z "$project_path"
        set project_path (current_project)
    end

    if test -z "$project_path"
        return 1
    end

    echo "Path: $project_path"
    echo "Name: "(project_name_from_path "$project_path")

    # Detect project type
    if test -f "$project_path/package.json"
        echo "Type: Node.js"
    else if test -f "$project_path/Cargo.toml"
        echo "Type: Rust"
    else if test -f "$project_path/go.mod"
        echo "Type: Go"
    else if test -d "$project_path/.git"
        echo "Type: Git repository"
    else
        echo "Type: Generic"
    end

    # Show size
    echo "Size: "(du -sh "$project_path" 2>/dev/null | cut -f1)
end
