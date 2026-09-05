<script>
  import Sidebar from './lib/components/Sidebar.svelte';
  import MarkdownRenderer from './lib/components/MarkdownRenderer.svelte';
  import HomePage from './lib/components/HomePage.svelte';
  import { currentPage, sidebarOpen, pages } from './lib/stores.js';
  import { pageContentMap } from './lib/content.js';

  $: currentTitle = $pages.find(p => p.id === $currentPage)?.title || 'SamDev Wiki';
  $: currentIcon = $pages.find(p => p.id === $currentPage)?.icon || '⚡';
  $: content = pageContentMap[$currentPage] || '';
</script>

<div class="app">
  <Sidebar />

  <main class="content">
    <header class="topbar">
      <button class="menu-btn" on:click={() => $sidebarOpen = true}>☰</button>
      <div class="topbar-title">
        <span>{currentIcon}</span>
        <span>{currentTitle}</span>
      </div>
      <div class="topbar-actions">
        <a href="https://github.com/Ramasanjaya22/samdev-wiki" target="_blank" rel="noopener" class="gh-link">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/>
          </svg>
        </a>
      </div>
    </header>

    <div class="page">
      {#if $currentPage === 'home'}
        <HomePage />
      {:else if typeof content === 'string'}
        <MarkdownRenderer {content} />
      {/if}
    </div>
  </main>
</div>

<style>
  :root {
    --bg-base: #0f0f14;
    --bg-sidebar: #13131a;
    --bg-card: #16161e;
    --bg-hover: #1e1e2a;
    --bg-input: #1a1a24;
    --bg-code: #1e1e2a;
    --bg-code-block: #12121a;
    --text-primary: #e8e8ed;
    --text-secondary: #9898a8;
    --text-muted: #5c5c6e;
    --accent: #6366f1;
    --accent-bg: rgba(99, 102, 241, 0.1);
    --border: #24243a;
    --radius: 8px;
  }

  :global(*) {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  :global(body) {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    background: var(--bg-base);
    color: var(--text-primary);
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

  :global(::selection) {
    background: var(--accent);
    color: white;
  }

  :global(::-webkit-scrollbar) {
    width: 6px;
  }

  :global(::-webkit-scrollbar-track) {
    background: transparent;
  }

  :global(::-webkit-scrollbar-thumb) {
    background: var(--border);
    border-radius: 3px;
  }

  .app {
    display: flex;
    min-height: 100vh;
  }

  .content {
    flex: 1;
    margin-left: 280px;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }

  .topbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 24px;
    border-bottom: 1px solid var(--border);
    background: var(--bg-sidebar);
    position: sticky;
    top: 0;
    z-index: 50;
    backdrop-filter: blur(12px);
  }

  .menu-btn {
    display: none;
    background: none;
    border: none;
    color: var(--text-secondary);
    font-size: 20px;
    cursor: pointer;
    padding: 4px 8px;
    border-radius: 6px;
  }

  .menu-btn:hover {
    background: var(--bg-hover);
  }

  .topbar-title {
    display: flex;
    align-items: center;
    gap: 8px;
    font-weight: 600;
    font-size: 15px;
  }

  .topbar-actions {
    display: flex;
    align-items: center;
  }

  .gh-link {
    color: var(--text-muted);
    padding: 6px;
    border-radius: 6px;
    transition: all 0.12s;
    display: flex;
    align-items: center;
  }

  .gh-link:hover {
    color: var(--text-primary);
    background: var(--bg-hover);
  }

  .page {
    flex: 1;
    max-width: 860px;
    margin: 0 auto;
    padding: 32px 40px;
    width: 100%;
  }

  @media (max-width: 768px) {
    .content {
      margin-left: 0;
    }

    .menu-btn {
      display: block;
    }

    .page {
      padding: 24px 20px;
    }
  }
</style>
