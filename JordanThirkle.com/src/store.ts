import { atom } from 'nanostores';

// State for the Command Palette (Cmd+K)
export const isSearchOpen = atom<boolean>(false);

// State for the Global Toast notifications
export type ToastType = 'success' | 'error' | 'info';

export interface ToastMessage {
  message: string;
  type: ToastType;
  id: number;
}

export const toastMessage = atom<ToastMessage | null>(null);

/**
 * Helper to trigger a toast from anywhere in the app (Astro or React)
 */
export function showToast(message: string, type: ToastType = 'info') {
  toastMessage.set({
    message,
    type,
    id: Date.now(),
  });
  
  // Auto-clear after 3 seconds
  setTimeout(() => {
    toastMessage.set(null);
  }, 3000);
}
