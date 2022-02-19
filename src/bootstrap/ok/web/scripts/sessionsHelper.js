const SESSIONS_STARTED = 'sessions_started';
const WARNING_MESSAGE = 'several_tabs_warning';

function SessionsHelper() {
    this.sessions = parseInt(localStorage.getItem(SESSIONS_STARTED)) || 0;
    this.messageSent = false;

    this.changeSessions = function(delta) {
        const sessions = parseInt(localStorage.getItem(SESSIONS_STARTED)) || 0;
        this.sessions = sessions + delta;

        localStorage.setItem(SESSIONS_STARTED, this.sessions);
        this.messageSent = false;
    }

    this.checkSessions = function() {
        if (this.messageSent) {
            return;
        }

        const sessions = parseInt(localStorage.getItem(SESSIONS_STARTED)) || 0;

        if (this.sessions != sessions) {
            JsToDef.send(WARNING_MESSAGE);
            this.messageSent = true;
        }
    }
}
