<script>
  import { homeContent } from '../content.js';
  import { currentPage } from '../stores.js';

  const data = homeContent;
</script>

<div class="hero">
  <h1>{data.title}</h1>
  <p class="subtitle">{data.description}</p>
  <div class="status" class:ok={data.status.ok}>
    <span class="status-dot"></span>
    {data.status.label}
  </div>
</div>

<div class="stats">
  {#each data.stats as stat}
    <div class="stat-card">
      <div class="stat-value">{stat.value}</div>
      <div class="stat-label">{stat.label}</div>
    </div>
  {/each}
</div>

<div class="features">
  {#each data.features as feat}
    <div class="feature-card">
      <div class="feature-icon">{feat.icon}</div>
      <h3>{feat.title}</h3>
      <p>{feat.desc}</p>
    </div>
  {/each}
</div>

<div class="cta">
  <button class="btn-primary" on:click={() => $currentPage = 'quick-start'}>
    🚀 Get Started
  </button>
  <a class="btn-secondary" href="https://github.com/Ramasanjaya22/samdev-wiki" target="_blank" rel="noopener">
    GitHub ↗
  </a>
</div>

<style>
  .hero {
    text-align: center;
    padding: 40px 0 32px;
  }

  .hero h1 {
    font-size: 36px;
    font-weight: 800;
    margin: 0 0 12px;
    background: linear-gradient(135deg, var(--accent), #a78bfa);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    line-height: 1.2;
  }

  .subtitle {
    font-size: 17px;
    color: var(--text-secondary);
    margin: 0 0 20px;
    max-width: 500px;
    margin-left: auto;
    margin-right: auto;
    line-height: 1.5;
  }

  .status {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 6px 16px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 500;
    background: var(--bg-hover);
    color: var(--text-secondary);
  }

  .status.ok {
    background: #052e16;
    color: #4ade80;
  }

  .status-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: currentColor;
    animation: pulse 2s infinite;
    flex-shrink: 0;
  }

  @keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
  }

  .stats {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 12px;
    margin-bottom: 32px;
  }

  .stat-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 20px 12px;
    text-align: center;
    min-width: 0;
  }

  .stat-value {
    font-size: 28px;
    font-weight: 800;
    color: var(--accent);
    line-height: 1;
  }

  .stat-label {
    font-size: 13px;
    color: var(--text-muted);
    margin-top: 6px;
  }

  .features {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
    margin-bottom: 32px;
  }

  .feature-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 24px;
    transition: border-color 0.15s, transform 0.15s;
    min-width: 0;
  }

  .feature-card:hover {
    border-color: var(--accent);
    transform: translateY(-2px);
  }

  .feature-icon {
    font-size: 28px;
    margin-bottom: 12px;
  }

  .feature-card h3 {
    font-size: 16px;
    font-weight: 700;
    margin: 0 0 8px;
    color: var(--text-primary);
  }

  .feature-card p {
    font-size: 14px;
    color: var(--text-secondary);
    margin: 0;
    line-height: 1.5;
  }

  .cta {
    display: flex;
    gap: 12px;
    justify-content: center;
    padding-bottom: 40px;
    flex-wrap: wrap;
  }

  .btn-primary {
    padding: 12px 28px;
    border-radius: 10px;
    border: none;
    background: var(--accent);
    color: white;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: opacity 0.15s;
    white-space: nowrap;
  }

  .btn-primary:hover {
    opacity: 0.9;
  }

  .btn-secondary {
    padding: 12px 28px;
    border-radius: 10px;
    border: 1px solid var(--border);
    background: transparent;
    color: var(--text-secondary);
    font-size: 15px;
    font-weight: 500;
    text-decoration: none;
    transition: all 0.15s;
    white-space: nowrap;
  }

  .btn-secondary:hover {
    border-color: var(--accent);
    color: var(--accent);
  }

  /* Tablet */
  @media (max-width: 900px) {
    .stats {
      grid-template-columns: repeat(2, 1fr);
    }
  }

  /* Mobile */
  @media (max-width: 768px) {
    .hero {
      padding: 24px 0 20px;
    }

    .hero h1 {
      font-size: 28px;
    }

    .subtitle {
      font-size: 15px;
    }

    .features {
      grid-template-columns: 1fr;
      gap: 12px;
    }

    .feature-card {
      padding: 20px;
    }

    .stat-card {
      padding: 16px 8px;
    }

    .stat-value {
      font-size: 24px;
    }

    .stat-label {
      font-size: 12px;
    }
  }

  /* Small mobile */
  @media (max-width: 400px) {
    .hero h1 {
      font-size: 24px;
    }

    .subtitle {
      font-size: 14px;
    }

    .stats {
      grid-template-columns: repeat(2, 1fr);
      gap: 8px;
    }

    .stat-card {
      padding: 12px 6px;
    }

    .stat-value {
      font-size: 22px;
    }

    .btn-primary,
    .btn-secondary {
      width: 100%;
      text-align: center;
      padding: 14px 20px;
    }

    .cta {
      flex-direction: column;
      gap: 8px;
    }
  }
</style>
