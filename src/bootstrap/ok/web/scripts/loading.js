const finishCounterDuration = 1000;
const loadingCounterDuration = 5000;
const fadeDuration = 200;
const PERCENTAGE = 100;
const deltaTime = 1000;
const loadingThreshold = 80;

function LoadingAnimator() {
    this.loadingText = document.getElementById('progressText');
    this.loadingProgressbar = document.getElementById('progressbar');
    this.loadingContainer = document.getElementById('loading_container');
    this.currentPercentage = 0;
    this.time = deltaTime;
    this.waitingTimerId;

    this.startAnimation = function() {
        this._setPercentage(this.currentPercentage);

        this._animateCounter(loadingCounterDuration, this.currentPercentage, loadingThreshold, () => {
            this.waitingTimerId = setTimeout(() => this._tick(), this.time);
        });
    };

    this._tick = function() {
        this._setPercentage(this.currentPercentage++);

        if (this.currentPercentage < PERCENTAGE) {
            this.time += deltaTime;
            this.waitingTimerId = setTimeout(() => this._tick(), this.time);
        }
    };

    this.loadGame = function() {
        clearTimeout(this.waitingTimerId);
        clearTimeout(this.counterTimerId);
        this._animateCounter(finishCounterDuration, this.currentPercentage, PERCENTAGE, () => {
            this.loadingContainer.classList.add('loading_finished');

            setTimeout(() => {
                document.getElementById('canvas').style.display = 'block';
                document.getElementById('loading_container').style.display = 'none';
            }, fadeDuration);
        });
    }

    this._setPercentage = function(percentage) {
        this.loadingText.textContent = percentage.toFixed(0) + '%';
        this.loadingProgressbar.style.width = percentage + '%';
    }

    this._animateCounter = function(duration, prev, next, callback) {
        const range = next - prev;
        let elapsedTime = 0;

        if (range == 0) {
            return;
        }

        const interval = duration / range;

        this.counterTimerId = setInterval(() => {
            elapsedTime += interval;

            const remainingTime = Math.max((duration - elapsedTime) / duration, 0);
            const current = Math.floor(next - remainingTime * range);

            this.currentPercentage = current;

            this._setPercentage(current);

            if (current == next) {
                clearInterval(this.counterTimerId);

                if (callback) {
                    callback();
                }
            }
        }, interval);
    }
}
