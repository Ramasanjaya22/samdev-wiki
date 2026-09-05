import { writable, derived } from 'svelte/store';

export const currentPage = writable('home');
export const sidebarOpen = writable(false);
export const searchQuery = writable('');

export const pages = writable([
  { id: 'home', title: 'Home', icon: '🏠', category: null },
  { id: 'quick-start', title: 'Quick Start', icon: '🚀', category: 'Getting Started' },
  { id: 'agent-setup', title: 'GitHub Auth & Setup', icon: '🔐', category: 'Getting Started' },
  { id: 'agents', title: 'Coding Agents', icon: '🤖', category: 'Architecture' },
  { id: 'cicd', title: 'Autonomous CI/CD', icon: '🔄', category: 'Architecture' },
  { id: 'scripts', title: 'Scripts Reference', icon: '📜', category: 'Reference' },
  { id: 'security', title: 'Security Rules', icon: '🛡️', category: 'Reference' },
  { id: 'troubleshooting', title: 'Troubleshooting', icon: '🔧', category: 'Reference' },
]);

export const filteredPages = derived(
  [pages, searchQuery],
  ([$pages, $searchQuery]) => {
    if (!$searchQuery.trim()) return $pages;
    const q = $searchQuery.toLowerCase();
    return $pages.filter(p => p.title.toLowerCase().includes(q));
  }
);
