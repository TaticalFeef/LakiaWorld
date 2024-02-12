class Component {
    constructor(containerId) {
        this.containerId = containerId;
        if (this.containerId) {
            this.container = document.getElementById(containerId);
        }
    }

    init() {
        console.log(`${this.containerId} inicializado.`);
    }
}
