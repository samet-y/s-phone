(function () {
    const container      = document.getElementById('phone-container');
    const menuTitle      = document.getElementById('menu-title');
    const directoryView  = document.getElementById('directory-view');
    const callView       = document.getElementById('call-view');
    const callTargets    = document.getElementById('call-targets');
    const callTargetName = document.getElementById('call-target-name');
    const incomingLabel  = document.getElementById('incoming-label');
    const ringtone       = document.getElementById('ringtone');

    let isOpen = false;

    // ========== NUI MESSAGE LISTENER ==========
    window.addEventListener('message', function (event) {
        var msg = event.data;

        switch (msg.action) {
            case 'openPhone':
                openPhone(msg.data);
                break;
            case 'closePhone':
                closePhone();
                break;
            case 'callStatus':
                updateCallStatus(msg.connected, msg.targetName);
                break;
            case 'playRingtone':
                playRingtone(msg.url, msg.volume);
                break;
            case 'stopRingtone':
                stopRingtone();
                break;
        }
    });

    // ========== KEYBOARD ==========
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && isOpen) {
            e.preventDefault();
            sendCallback('closePhone', {});
        }
    });

    // ========== RINGTONE ==========
    function playRingtone(url, volume) {
        if (!url) return;
        ringtone.src = url;
        ringtone.volume = volume || 0.3;
        ringtone.play().catch(function () {});
    }

    function stopRingtone() {
        ringtone.pause();
        ringtone.currentTime = 0;
        ringtone.src = '';
    }

    // ========== OPEN PHONE ==========
    function openPhone(data) {
        isOpen = true;

        // Set title
        menuTitle.textContent = data.menuTitle || 'Communication Ltd.';

        // Set incoming calls label
        if (data.locale && data.locale.incomingCalls) {
            incomingLabel.textContent = data.locale.incomingCalls;
        }

        // Build call target buttons
        callTargets.innerHTML = '';
        if (data.callTargets) {
            data.callTargets.forEach(function (target) {
                var item = document.createElement('div');
                item.className = 'call-item';
                item.onclick = function () { selectTarget(target.id); };
                item.innerHTML =
                    '<span class="call-icon">&#9742;</span>' +
                    '<span>' + escapeHtml(target.label) + '</span>' +
                    '<span class="call-arrow">&#10148;</span>';
                callTargets.appendChild(item);
            });
        }

        // Show directory, hide call view
        directoryView.classList.remove('hidden');
        callView.classList.add('hidden');

        // Show container
        container.classList.remove('hidden');
        container.style.animation = 'fadeIn 0.3s ease-out';
    }

    // ========== CLOSE PHONE ==========
    function closePhone() {
        if (!isOpen) return;
        isOpen = false;
        stopRingtone();

        container.style.animation = 'fadeOut 0.2s ease-in forwards';
        setTimeout(function () {
            container.classList.add('hidden');
            container.style.animation = '';
        }, 200);
    }

    // ========== CALL STATUS ==========
    function updateCallStatus(connected, targetName) {
        if (connected) {
            directoryView.classList.add('hidden');
            callView.classList.remove('hidden');
            callTargetName.textContent = targetName || '';
        } else {
            stopRingtone();
            directoryView.classList.remove('hidden');
            callView.classList.add('hidden');
        }
    }

    // ========== ACTIONS ==========
    function selectTarget(targetId) {
        sendCallback('selectTarget', { targetId: targetId });
    }

    window.answerIncoming = function () {
        sendCallback('answerIncoming', {});
    };

    window.hangUp = function () {
        stopRingtone();
        sendCallback('hangUp', {});
    };

    // ========== UTILITIES ==========
    function sendCallback(name, data) {
        fetch('https://' + GetParentResourceName() + '/' + name, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
    }

    function escapeHtml(text) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(text));
        return div.innerHTML;
    }
})();
