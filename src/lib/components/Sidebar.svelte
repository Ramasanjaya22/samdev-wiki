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
    <div class="logo">
      <span class="logo-icon">⚡</span>
      <span class="logo-text">SamDev Wiki</span>
    </div>
    <button class="close-btn" on:click={() => $sidebarOpen = false}>✕</button>
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
  </div>
</aside>

{#if $sidebarOpen}
  <div class="overlay" on:click={() => $sidebarOpen = false} role="presentation"></div>
{/if}

<style>
  .sidebar {
    position: fixed;
    top: 0;
    left: 0;
    width: 280px;
    height: 100vh;
    background: var(--bg-sidebar);
    border-right: 1px solid var(--border);
    display: flex;
    flex-direction: column;
    z-index: 100;
    overflow-y: auto;
    transition: transform 0.2s ease;
  }

  .sidebar-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16px 20px;
    border-bottom: 1px solid var(--border);
  }

  .logo {
    display: flex;
    align-items: center;
    gap: 8px;
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
    font-size: 18px;
    padding: 4px 8px;
  }

  .search-box {
    padding: 12px 16px;
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
    padding: 8px 12px;
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
  }

  .sidebar-footer {
    padding: 12px 16px;
    border-top: 1px solid var(--border);
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

  .overlay {
    display: none;
  }

  @media (max-width: 768px) {
    .sidebar {
      transform: translateX(-100%);
    }

    .sidebar.open {
      transform: translateX(0);
    }

    .close-btn {
      display: block;
    }

    .overlay {
      display: block;
      position: fixed;
      inset: 0;
      background: rgba(0, 0, 0, 0.5);
      z-index: 99;
    }
  }
</style>
