<script>
  import { marked } from 'marked';

  export let content = '';

  marked.setOptions({
    gfm: true,
    breaks: false,
  });

  $: html = typeof content === 'string' ? marked.parse(content) : '';
</script>

<div class="markdown-body">
  {@html html}
</div>

<style>
  .markdown-body {
    line-height: 1.7;
    color: var(--text-primary);
    overflow-wrap: break-word;
    word-break: break-word;
  }

  .markdown-body :global(h1) {
    font-size: 28px;
    font-weight: 800;
    margin: 0 0 20px;
    padding-bottom: 12px;
    border-bottom: 2px solid var(--border);
    color: var(--text-primary);
    line-height: 1.3;
  }

  .markdown-body :global(h2) {
    font-size: 22px;
    font-weight: 700;
    margin: 32px 0 12px;
    color: var(--text-primary);
    line-height: 1.3;
  }

  .markdown-body :global(h3) {
    font-size: 17px;
    font-weight: 600;
    margin: 24px 0 8px;
    color: var(--text-primary);
  }

  .markdown-body :global(p) {
    margin: 0 0 16px;
    color: var(--text-secondary);
  }

  .markdown-body :global(strong) {
    color: var(--text-primary);
    font-weight: 600;
  }

  .markdown-body :global(a) {
    color: var(--accent);
    text-decoration: none;
    word-break: break-all;
  }

  .markdown-body :global(a:hover) {
    text-decoration: underline;
  }

  .markdown-body :global(code) {
    font-family: 'SF Mono', 'Fira Code', 'Cascadia Code', monospace;
    font-size: 0.85em;
    background: var(--bg-code);
    padding: 2px 6px;
    border-radius: 4px;
    color: var(--accent);
    word-break: break-all;
  }

  .markdown-body :global(pre) {
    background: var(--bg-code-block);
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: 16px 20px;
    overflow-x: auto;
    margin: 0 0 16px;
    -webkit-overflow-scrolling: touch;
  }

  .markdown-body :global(pre code) {
    background: none;
    padding: 0;
    color: var(--text-primary);
    font-size: 13px;
    line-height: 1.6;
    word-break: normal;
    white-space: pre;
  }

  .markdown-body :global(ul),
  .markdown-body :global(ol) {
    margin: 0 0 16px;
    padding-left: 24px;
    color: var(--text-secondary);
  }

  .markdown-body :global(li) {
    margin-bottom: 4px;
  }

  .markdown-body :global(li > ul),
  .markdown-body :global(li > ol) {
    margin-top: 4px;
    margin-bottom: 0;
  }

  .markdown-body :global(hr) {
    border: none;
    border-top: 1px solid var(--border);
    margin: 28px 0;
  }

  /* Tables — scrollable wrapper */
  .markdown-body :global(table) {
    width: 100%;
    border-collapse: collapse;
    margin: 0 0 16px;
    font-size: 14px;
    display: block;
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
  }

  .markdown-body :global(thead),
  .markdown-body :global(tbody) {
    min-width: 300px;
  }

  .markdown-body :global(th),
  .markdown-body :global(td) {
    text-align: left;
    padding: 10px 14px;
    border-bottom: 1px solid var(--border);
    white-space: nowrap;
  }

  .markdown-body :global(th) {
    font-weight: 600;
    color: var(--text-primary);
    background: var(--bg-hover);
  }

  .markdown-body :global(td) {
    color: var(--text-secondary);
  }

  .markdown-body :global(blockquote) {
    border-left: 3px solid var(--accent);
    margin: 0 0 16px;
    padding: 8px 16px;
    background: var(--bg-hover);
    border-radius: 0 8px 8px 0;
  }

  .markdown-body :global(blockquote p) {
    margin: 0;
  }

  .markdown-body :global(img) {
    max-width: 100%;
    height: auto;
    border-radius: 8px;
  }

  /* Checkbox list items */
  .markdown-body :global(li:has(input[type="checkbox"])) {
    list-style: none;
    margin-left: -20px;
  }

  .markdown-body :global(input[type="checkbox"]) {
    margin-right: 6px;
    accent-color: var(--accent);
  }

  /* Mobile */
  @media (max-width: 768px) {
    .markdown-body :global(h1) {
      font-size: 24px;
    }

    .markdown-body :global(h2) {
      font-size: 19px;
      margin: 24px 0 10px;
    }

    .markdown-body :global(h3) {
      font-size: 16px;
    }

    .markdown-body :global(pre) {
      padding: 12px 14px;
      border-radius: 8px;
      margin-left: -4px;
      margin-right: -4px;
    }

    .markdown-body :global(pre code) {
      font-size: 12px;
    }

    .markdown-body :global(code) {
      font-size: 0.8em;
      padding: 1px 4px;
    }

    .markdown-body :global(th),
    .markdown-body :global(td) {
      padding: 8px 10px;
      font-size: 13px;
    }

    .markdown-body :global(ul),
    .markdown-body :global(ol) {
      padding-left: 20px;
    }

    .markdown-body :global(blockquote) {
      padding: 6px 12px;
    }
  }

  /* Small mobile */
  @media (max-width: 400px) {
    .markdown-body :global(h1) {
      font-size: 21px;
    }

    .markdown-body :global(h2) {
      font-size: 17px;
    }

    .markdown-body :global(h3) {
      font-size: 15px;
    }

    .markdown-body :global(pre) {
      padding: 10px 10px;
      margin-left: -8px;
      margin-right: -8px;
      border-radius: 6px;
    }

    .markdown-body :global(pre code) {
      font-size: 11px;
      line-height: 1.5;
    }

    .markdown-body :global(table) {
      font-size: 12px;
    }
  }
</style>
