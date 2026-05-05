import React from 'react';
import { activeBlogTag, activeBlogView } from '@/store/blog';
import { FilterControls } from './FilterControls';

interface Props {
  categories: string[];
}

export const BlogFilters: React.FC<Props> = ({ categories }) => {
  return (
    <FilterControls
      categories={categories}
      filterStore={activeBlogTag}
      viewStore={activeBlogView}
      filterParamKey="tag"
    />
  );
};
