class Menu {
    constructor(menu, trigger) {
        for (let eventName of ['click', 'tap']) {
            trigger.addEventListener(eventName, (e) => {
                menu.classList.toggle('expanded');
            });
        }
    }
}
export default Menu;
