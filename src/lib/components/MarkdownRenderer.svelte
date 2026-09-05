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
  }

  .markdown-body :global(h1) {
    font-size: 28px;
    font-weight: 800;
    margin: 0 0 20px;
    padding-bottom: 12px;
    border-bottom: 2px solid var(--border);
    color: var(--text-primary);
  }

  .markdown-body :global(h2) {
    font-size: 22px;
    font-weight: 700;
    margin: 32px 0 12px;
    color: var(--text-primary);
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
  }

  .markdown-body :global(a:hover) {
    text-decoration: underline;
  }

  .markdown-body :global(code) {
    font-family: 'SF Mono', 'Fira Code', monospace;
    font-size: 13px;
    background: var(--bg-code);
    padding: 2px 6px;
    border-radius: 4px;
    color: var(--accent);
  }

  .markdown-body :global(pre) {
    background: var(--bg-code-block);
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: 16px 20px;
    overflow-x: auto;
    margin: 0 0 16px;
  }

  .markdown-body :global(pre code) {
    background: none;
    padding: 0;
    color: var(--text-primary);
    font-size: 13px;
    line-height: 1.6;
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

  .markdown-body :global(hr) {
    border: none;
    border-top: 1px solid var(--border);
    margin: 28px 0;
  }

  .markdown-body :global(table) {
    width: 100%;
    border-collapse: collapse;
    margin: 0 0 16px;
    font-size: 14px;
  }

  .markdown-body :global(th),
  .markdown-body :global(td) {
    text-align: left;
    padding: 10px 14px;
    border-bottom: 1px solid var(--border);
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
</style>
