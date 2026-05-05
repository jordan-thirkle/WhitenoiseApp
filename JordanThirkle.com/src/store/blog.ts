import { atom } from 'nanostores';

export type BlogView = 'grid' | 'timeline';

export const activeBlogTag = atom<string | null>(null);
export const activeBlogView = atom<BlogView>('grid');
