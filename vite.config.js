import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
        tailwindcss(),
    ],
     server: {
        host: '0.0.0.0',  // Listen on all interfaces to be accessible from outside the container
        // port: 5173,       // Default Vite port
        // strictPort: true, // Fail if the port is already in use
        hmr: {
            host: 'localhost'  // Tell browser to connect to localhost for hot module replacement
        },
    }
});
