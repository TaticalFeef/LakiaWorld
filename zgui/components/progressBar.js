class ProgressBar extends Component {
    constructor(containerId, initialValue = 100) {
        super(containerId);
        this.initialValue = initialValue;
        this.init();
    }

    init() {
        super.init();
        if (!this.container) return;
        this.addStyles();
        this.container.innerHTML = `
            <div class="progress-view-template>
                <div class="progress-view-container">
                    <div class="progress-view-bar" style="width: ${this.initialValue}%;"></div>
                    <span class="progress-view-text">${this.initialValue}%</span>
                </div>
            </div>
        `;

        
    }

    addStyles() {
        const style = document.createElement('style');
        style.style = `
            .progress-view-container {
                display: flex;
                justify-content: center;
                align-items: center;
                width: 100%;
                height: 30px;
                background-color: #eee;
                border-radius: 15px;
                border: 4px solid black;
                position: relative;
                box-sizing: border-box;
            }

            .progress-view-bar {
                width: 100%;
                height: 100%;
                max-width: 100%;
                background-color: #4CAF50;
                border-radius: 12px;
                transition: width 0.3s ease;
                box-sizing: border-box;
            }

            .progress-view-text {
                position: absolute;
                left: 50%;
                top: 10%;
                transform: translateX(-50%);
                color: black;
                font-weight: bold;
                z-index: 2;
            }

            .progress-view-template {
                width: 100%;
                height: 100vh;
                display: flex;
                align-content: center;
                justify-content: center;
                flex-wrap: wrap;
                align-items: center;
            }
        `;
        document.head.appendChild(style);
    }

    update(value) {
        const progressBar = this.container.querySelector('.progress-view-bar');
        const progressText = this.container.querySelector('.progress-view-text');
        const newValue = Math.min(100, Math.max(0, value));

        progressBar.style.width = `${newValue}%`;
        progressText.innerText = `${newValue}%`;
    }
}
