import { onMount } from 'svelte';

let user = 'Guest';
let count = 0;

onMount(() => {
    user = 'Agent Swarm';
});

function increment() {
    count += 1;
}

function decrement() {
    count -= 1;
}

export default {
    script: true
};