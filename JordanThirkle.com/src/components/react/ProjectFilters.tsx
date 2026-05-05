import React from 'react';
import { activeProjectFilter, activeProjectsView } from '@/store/projects';
import { FilterControls } from './FilterControls';

interface Props {
  categories: string[];
}

export const ProjectFilters: React.FC<Props> = ({ categories }) => {
  return (
    <FilterControls
      categories={categories}
      filterStore={activeProjectFilter}
      viewStore={activeProjectsView}
      filterParamKey="filter"
    />
  );
};
