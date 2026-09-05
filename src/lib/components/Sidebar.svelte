<script>
  import { currentPage, sidebarOpen, searchQuery, filteredPages } from '../stores.js';

  function navigate(id) {
    $currentPage = id;
    $sidebarOpen = false;
    window.scrollTo(0, 0);
  }

  $: categories = (() => {
    const groups = {};
    for (const p of $filteredPages) {
      const cat = p.category || '_root';
      if (!groups[cat]) groups[cat] = [];
      groups[cat].push(p);
    }
    return groups;
  })();
</script>

<aside class="sidebar" class:open={$sidebarOpen}>
  <div class="sidebar-header">
    <div class="logo" role="button" tabindex="0" on:click={() => navigate('home')} on:keydown={(e) => e.key === 'Enter' && navigate('home')}>
      <span class="logo-icon">⚡</span>
      <span class="logo-text">SamDev Wiki</span>
    </div>
    <button class="close-btn" on:click={() => $sidebarOpen = false} aria-label="Close menu">✕</button>
  </div>

  <div class="search-box">
    <input
      type="text"
      placeholder="Search docs..."
      bind:value={$searchQuery}
    />
  </div>

  <nav>
    {#each Object.entries(categories) as [cat, pages]}
      {#if cat !== '_root'}
        <div class="nav-category">{cat}</div>
      {/if}
      {#each pages as page}
        <button
          class="nav-item"
          class:active={$currentPage === page.id}
          on:click={() => navigate(page.id)}
        >
          <span class="nav-icon">{page.icon}</span>
          <span class="nav-label">{page.title}</span>
        </button>
      {/each}
    {/each}
  </nav>

  <div class="sidebar-footer">
    <a href="https://github.com/Ramasanjaya22/samdev-wiki" target="_blank" rel="noopener">
      GitHub ↗
    </a>
    <span class="version">v0.2.0</span>
  </div>
</aside>

{#if $sidebarOpen}
  <div class="overlay" on:click={() => $sidebarOpen = false} on:keydown={(e) => e.key === 'Escape' && ($sidebarOpen = false)} role="presentation"></div>
{/if}

<style>
  .sidebar {
    position: fixed;
    top: 0;
    left: 0;
    width: 280px;
    height: 100vh;
    height: 100dvh;
    background: var(--bg-sidebar);
    border-right: 1px solid var(--border);
    display: flex;
    flex-direction: column;
    z-index: 100;
    overflow-y: auto;
    overflow-x: hidden;
    transition: transform 0.2s ease;
  }

  .sidebar-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16px 20px;
    border-bottom: 1px solid var(--border);
    flex-shrink: 0;
  }

  .logo {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    user-select: none;
  }

  .logo-icon {
    font-size: 20px;
  }

  .logo-text {
    font-weight: 700;
    font-size: 16px;
    color: var(--text-primary);
  }

  .close-btn {
    display: none;
    background: none;
    border: none;
    color: var(--text-secondary);
    cursor: pointer;
    font-size: 20px;
    padding: 6px 10px;
    border-radius: 6px;
    line-height: 1;
  }

  .close-btn:hover {
    background: var(--bg-hover);
  }

  .search-box {
    padding: 12px 16px;
    flex-shrink: 0;
  }

  .search-box input {
    width: 100%;
    padding: 8px 12px;
    border-radius: 8px;
    border: 1px solid var(--border);
    background: var(--bg-input);
    color: var(--text-primary);
    font-size: 14px;
    outline: none;
    transition: border-color 0.15s;
  }

  .search-box input:focus {
    border-color: var(--accent);
  }

  .search-box input::placeholder {
    color: var(--text-muted);
  }

  nav {
    flex: 1;
    padding: 8px 12px;
    overflow-y: auto;
    overflow-x: hidden;
  }

  .nav-category {
    font-size: 11px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--text-muted);
    padding: 16px 8px 6px;
  }

  .nav-item {
    display: flex;
    align-items: center;
    gap: 10px;
    width: 100%;
    padding: 10px 12px;
    border: none;
    background: none;
    border-radius: 8px;
    cursor: pointer;
    color: var(--text-secondary);
    font-size: 14px;
    text-align: left;
    transition: all 0.12s;
  }

  .nav-item:hover {
    background: var(--bg-hover);
    color: var(--text-primary);
  }

  .nav-item.active {
    background: var(--accent-bg);
    color: var(--accent);
    font-weight: 600;
  }

  .nav-icon {
    font-size: 16px;
    width: 24px;
    text-align: center;
    flex-shrink: 0;
  }

  .nav-label {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .sidebar-footer {
    padding: 12px 16px;
    border-top: 1px solid var(--border);
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-shrink: 0;
  }

  .sidebar-footer a {
    color: var(--text-muted);
    text-decoration: none;
    font-size: 13px;
    transition: color 0.12s;
  }

  .sidebar-footer a:hover {
    color: var(--accent);
  }

  .version {
    font-size: 11px;
    color: var(--text-muted);
    opacity: 0.6;
  }

  .overlay {
    display: none;
  }

  /* Mobile: sidebar becomes drawer */
  @media (max-width: 768px) {
    .sidebar {
      transform: translateX(-100%);
      width: 300px;
      box-shadow: 4px 0 24px rgba(0, 0, 0, 0.4);
    }

    .sidebar.open {
      transform: translateX(0);
    }

    .close-btn {
      display: flex;
    }

    .overlay {
      display: block;
      position: fixed;
      inset: 0;
      background: rgba(0, 0, 0, 0.5);
      z-index: 99;
      -webkit-tap-highlight-color: transparent;
    }
  }

  /* Small mobile */
  @media (max-width: 400px) {
    .sidebar {
      width: 85vw;
      max-width: 300px;
    }
  }
</style>
