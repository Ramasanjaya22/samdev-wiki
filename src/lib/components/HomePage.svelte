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
  }

  .subtitle {
    font-size: 17px;
    color: var(--text-secondary);
    margin: 0 0 20px;
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
    padding: 20px;
    text-align: center;
  }

  .stat-value {
    font-size: 28px;
    font-weight: 800;
    color: var(--accent);
  }

  .stat-label {
    font-size: 13px;
    color: var(--text-muted);
    margin-top: 4px;
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
  }

  .btn-secondary:hover {
    border-color: var(--accent);
    color: var(--accent);
  }

  @media (max-width: 600px) {
    .hero h1 { font-size: 28px; }
    .stats { grid-template-columns: repeat(2, 1fr); }
    .features { grid-template-columns: 1fr; }
  }
</style>
