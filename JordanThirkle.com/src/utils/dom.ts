/**
 * Shared DOM filtering logic for category-based elements.
 * Toggles the 'hidden' class based on the element's data-category attribute.
 */
export const applyCategoryFilter = (
  elements: NodeListOf<Element> | Element[],
  filter: string | null
) => {
  elements.forEach((el) => {
    const element = el as HTMLElement;
    const category = element.dataset.category;
    if (!filter || category === filter) {
      element.classList.remove('hidden');
    } else {
      element.classList.add('hidden');
    }
  });
};
