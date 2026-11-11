# issabel-missed-call-callback

Missed-call callback routing for Issabel PBX (chan_sip). No module to install: one shell script and one block of `extensions_custom.conf`.

برگشت تماس به داخلیِ تماس‌گیرنده در ایزابل (chan_sip)، بدون نصب ماژول: یک اسکریپت و یک تکه دایال‌پلن.

## What it does

An extension calls a customer who does not answer. When the customer calls back within 3 hours, they hear a prompt: press **1** to reach the extension that called them; any other key or a 5 s timeout sends them to the normal inbound route (IVR). Callers with no recent missed call go straight to the normal route.

## Install

Written on an Issabel server running Asterisk 18 with chan_sip. Back up `/etc/asterisk/extensions_custom.conf` first.

1. Copy `lastcaller.sh` to `/usr/local/bin/` and `chmod 755` it. Set `EXT_LEN` inside it to the length of your extensions.
2. Append `extensions_custom.conf` from this repo to `/etc/asterisk/extensions_custom.conf`. If your trunk has a channel limit, set `OUT_1` to the value used in `[from-trunk-sip-YOURTRUNK]` in `extensions_additional.conf`.
3. Upload a recording named `callback-prompt` in **PBX → System Recordings** (wav, 8 kHz, mono).
4. Run `asterisk -rx "dialplan reload"`.
5. In the trunk's **PEER Details** add `context=from-trunk-callback` and Apply. To undo, remove that line.

## Limits

- The lookup matches the last 10 digits of the caller ID, which suits Iranian numbering; adjust `lastcaller.sh` for other plans.
- If an extension's voicemail answers before the 20 s ring ends, the caller lands in voicemail instead of the IVR.
- Written for chan_sip trunks; the trunk context setting differs on PJSIP.

## See also

[issabel-campon](https://github.com/kiamiix/issabel-campon): ring me back when a busy extension is free.

## License

MIT
