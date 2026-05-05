import { atom } from 'nanostores';

export type ProjectView = 'grid' | 'timeline';

export const activeProjectFilter = atom<string | null>(null);
export const activeProjectsView = atom<ProjectView>('grid');
