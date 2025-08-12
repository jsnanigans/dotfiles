# opencode AI Agents Docs

Agents are specialized AI assistants that can be configured for specific tasks and workflows. They allow you to create focused tools with custom prompts, models, and tool access.

Tip

Use the plan agent to analyze code and review suggestions without making any code changes.

You can switch between agents during a session or invoke them with the `@` mention.

---

## [Types](https://opencode.ai/docs/agents/#types)

There are two types of agents in opencode; primary agents and subagents.

---

### [Primary agents](https://opencode.ai/docs/agents/#primary-agents)

Primary agents are the main assistants you interact with directly. You can cycle through them using the **Tab** key, or your configured `switch_agent` keybind. These agents handle your main conversation and can access all configured tools.

Tip

You can use the **Tab** key to switch between primary agents during a session.

opencode comes with two built-in primary agents, **Build** and **Plan**. We’ll look at these below.

---

### [Subagents](https://opencode.ai/docs/agents/#subagents)

Subagents are specialized assistants that primary agents can invoke for specific tasks. You can also manually invoke them by **@ mentioning** them in your messages.

opencode comes with one built-in subagent, **General**. We’ll look at this below.

---

## [Built-in](https://opencode.ai/docs/agents/#built-in)

opencode comes with two built-in primary agents and one built-in subagent.

---

### [Build](https://opencode.ai/docs/agents/#build)

_Mode_: `primary`

Build is the **default** primary agent with all tools enabled. This is the standard agent for development work where you need full access to file operations and system commands.

---

### [Plan](https://opencode.ai/docs/agents/#plan)

_Mode_: `primary`

A restricted agent designed for planning and analysis. In the plan agent, the following tools are disabled by default:

- `write` - Cannot create new files
- `edit` - Cannot modify existing files
- `patch` - Cannot apply patches
- `bash` - Cannot execute shell commands

This agent is useful when you want the LLM to analyze code, suggest changes, or create plans without making any actual modifications to your codebase.

---

### [General](https://opencode.ai/docs/agents/#general)

_Mode_: `subagent`

A general-purpose agent for researching complex questions, searching for code, and executing multi-step tasks. Use when searching for keywords or files and you’re not confident you’ll find the right match in the first few tries.

---

## [Usage](https://opencode.ai/docs/agents/#usage)

1. For primary agents, use the **Tab** key to cycle through them during a session. You can also use your configured `switch_agent` keybind.

2. Subagents can be invoked:

    - **Automatically** by primary agents for specialized tasks based on their descriptions.

    - Manually by **@ mentioning** a subagent in your message. For example.

        ```
        @general help me search for this function
        ```


---

## [Configure](https://opencode.ai/docs/agents/#configure)

You can customize the built-in agents or create your own through configuration. Agents can be configured in two ways:

---

### [JSON](https://opencode.ai/docs/agents/#json)

Configure agents in your `opencode.json` config file:

opencode.json

```
{  "$schema": "https://opencode.ai/config.json",  "agent": {    "build": {      "mode": "primary",      "model": "anthropic/claude-sonnet-4-20250514",      "prompt": "{file:./prompts/build.txt}",      "tools": {        "write": true,        "edit": true,        "bash": true      }    },    "plan": {      "mode": "primary",      "model": "anthropic/claude-haiku-4-20250514",      "tools": {        "write": false,        "edit": false,        "bash": false      }    },    "code-reviewer": {      "description": "Reviews code for best practices and potential issues",      "mode": "subagent",      "model": "anthropic/claude-sonnet-4-20250514",      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",      "tools": {        "write": false,        "edit": false      }    }  }}
```

---

### [Markdown](https://opencode.ai/docs/agents/#markdown)

You can also define agents using markdown files. Place them in:

- Global: `~/.config/opencode/agent/`
- Per-project: `.opencode/agent/`

~/.config/opencode/agent/review.md

```
---description: Reviews code for quality and best practicesmode: subagentmodel: anthropic/claude-sonnet-4-20250514temperature: 0.1tools:  write: false  edit: false  bash: false---
You are in code review mode. Focus on:
- Code quality and best practices- Potential bugs and edge cases- Performance implications- Security considerations
Provide constructive feedback without making direct changes.
```

The markdown file name becomes the agent name. For example, `review.md` creates a `review` agent.

Let’s look at these configuration options in detail.

---

## [Options](https://opencode.ai/docs/agents/#options)

Let’s look at these configuration options in detail.

---

### [Description](https://opencode.ai/docs/agents/#description)

Use the `description` option to provide a brief description of what the agent does and when to use it.

opencode.json

```
{  "agent": {    "review": {      "description": "Reviews code for best practices and potential issues"    }  }}
```

This is a **required** config option.

---

### [Temperature](https://opencode.ai/docs/agents/#temperature)

Control the randomness and creativity of the LLM’s responses with the `temperature` config.

Lower values make responses more focused and deterministic, while higher values increase creativity and variability.

opencode.json

```
{  "agent": {    "plan": {      "temperature": 0.1    },    "creative": {      "temperature": 0.8    }  }}
```

Temperature values typically range from 0.0 to 1.0:

- **0.0-0.2**: Very focused and deterministic responses, ideal for code analysis and planning
- **0.3-0.5**: Balanced responses with some creativity, good for general development tasks
- **0.6-1.0**: More creative and varied responses, useful for brainstorming and exploration

opencode.json

```
{  "agent": {    "analyze": {      "temperature": 0.1,      "prompt": "{file:./prompts/analysis.txt}"    },    "build": {      "temperature": 0.3    },    "brainstorm": {      "temperature": 0.7,      "prompt": "{file:./prompts/creative.txt}"    }  }}
```

If no temperature is specified, opencode uses model-specific defaults; typically 0 for most models, 0.55 for Qwen models.

---

### [Disable](https://opencode.ai/docs/agents/#disable)

Set to `true` to disable the agent.

opencode.json

```
{  "agent": {    "review": {      "disable": true    }  }}
```

---

### [Prompt](https://opencode.ai/docs/agents/#prompt)

Specify a custom system prompt file for this agent with the `prompt` config. The prompt file should contain instructions specific to the agent’s purpose.

opencode.json

```
{  "agent": {    "review": {      "prompt": "{file:./prompts/code-review.txt}"    }  }}
```

This path is relative to where the config file is located. So this works for both the global opencode config and the project specific config.

---

### [Model](https://opencode.ai/docs/agents/#model)

Use the `model` config to override the default model for this agent. Useful for using different models optimized for different tasks. For example, a faster model for planning, a more capable model for implementation.

opencode.json

```
{  "agent": {    "plan": {      "model": "anthropic/claude-haiku-4-20250514"    }  }}
```

---

### [Tools](https://opencode.ai/docs/agents/#tools)

Control which tools are available in this agent with the `tools` config. You can enable or disable specific tools by setting them to `true` or `false`.

opencode.json

```
{  "agent": {    "readonly": {      "tools": {        "write": false,        "edit": false,        "bash": false,        "read": true,        "grep": true,        "glob": true      }    }  }}
```

You can also use wildcards to control multiple tools at once. For example, to disable all tools from an MCP server:

opencode.json

```
{  "agent": {    "readonly": {      "tools": {        "mymcp_*": false,        "write": false,        "edit": false      }    }  }}
```

If no tools are specified, all tools are enabled by default.

---

#### [Available tools](https://opencode.ai/docs/agents/#available-tools)

Here are all the tools can be controlled through the agent config.

|Tool|Description|
|---|---|
|`bash`|Execute shell commands|
|`edit`|Modify existing files|
|`write`|Create new files|
|`read`|Read file contents|
|`grep`|Search file contents|
|`glob`|Find files by pattern|
|`list`|List directory contents|
|`patch`|Apply patches to files|
|`todowrite`|Manage todo lists|
|`todoread`|Read todo lists|
|`webfetch`|Fetch web content|

---

### [Mode](https://opencode.ai/docs/agents/#mode)

Control the agent’s mode with the `mode` config. The `mode` option is used to determine how the agent can be used.

opencode.json

```
{  "agent": {    "review": {      "mode": "subagent"    }  }}
```

The `mode` option can be set to `primary`, `subagent`, or `all`. If no `mode` is specified, it defaults to `all`.

---

### [Additional](https://opencode.ai/docs/agents/#additional)

Any other options you specify in your agent configuration will be **passed through directly** to the provider as model options. This allows you to use provider-specific features and parameters.

For example, with OpenAI’s reasoning models, you can control the reasoning effort:

opencode.json

```
{  "agent": {    "deep-thinker": {      "description": "Agent that uses high reasoning effort for complex problems",      "model": "openai/gpt-5-turbo",      "reasoningEffort": "high",      "textVerbosity": "low"    }  }}
```

These additional options are model and provider-specific. Check your provider’s documentation for available parameters.

---

## [Create agents](https://opencode.ai/docs/agents/#create-agents)

You can create new agents using the following command:

Terminal window

```
opencode agent create
```

This interactive command will:

1. Ask where to save the agent; global or project-specific.
2. Description of what the agent should do.
3. Generate an appropriate system prompt and identifier.
4. Let you select which tools the agent can access.
5. Finally, create a markdown file with the agent configuration.
