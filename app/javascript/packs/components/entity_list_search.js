const entityListEl = document.querySelector('.js-entities-list');

if (entityListEl){
  const searchInputEl = entityListEl.querySelector('.js-search-input');
  const entityItemEls = entityListEl.querySelectorAll('.js-entity-item');
  searchInputEl.addEventListener('input', (event) => {
    const searchText = event.target.value.toLowerCase();
    entityItemEls.forEach((itemEl) => {
      const word = itemEl.dataset.entity;
      if (word.includes(searchText)){
        itemEl.classList.remove('d-none');
      } else {
        itemEl.classList.add('d-none');
      }
    });
  });
}
