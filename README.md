# issabel-callback-campon

Two small dialplan add-ons for Issabel PBX (chan_sip). No module to install: one shell script and one block of `extensions_custom.conf`.

دو قابلیت کوچک برای ایزابل (chan_sip)، بدون نصب ماژول: یک اسکریپت و یک تکه دایال‌پلن.

## 1. Missed-call callback routing / برگشت تماس به داخلیِ تماس‌گیرنده

An extension calls a customer who does not answer. When the customer calls back within 3 hours, they hear a prompt: press **1** to reach the extension that called them; any other key or a 5 s timeout sends them to the normal inbound route (IVR).

از داخل شرکت به کسی زنگ می‌زنید و جواب نمی‌دهد. اگر تا ۳ ساعت بعد خودش تماس بگیرد، پیامی می‌شنود: با **۱** به همان داخلی وصل می‌شود؛ با هر کلید دیگر یا ۵ ثانیه سکوت به مسیر عادی (IVR) می‌رود.

## 2. Camp-on / خبرم کن وقتی آزاد شد

An extension calls another extension that is on a call. A prompt plays: press **1**, hang up, and the server rings you back as soon as both phones are free (max 30 min), then dials the other extension when you pick up. Without **1** the call continues as a normal call-waiting call.

به داخلی‌ای زنگ می‌زنید که مشغول است. پیام پخش می‌شود: با **۱** تماس قطع می‌شود و هر وقت هر دو گوشی آزاد شدند (حداکثر ۳۰ دقیقه) گوشی شما زنگ می‌خورد و با برداشتن، داخلی مقصد گرفته می‌شود. بدون زدن ۱ تماس مثل قبل پشت‌خطی می‌شود.

## Install / نصب

Written on an Issabel server running Asterisk 18 with chan_sip. Back up `/etc/asterisk/extensions_custom.conf` first.

1. Copy `lastcaller.sh` to `/usr/local/bin/` and `chmod 755` it. Set `EXT_LEN` inside it to the length of your extensions.
2. Append `extensions_custom.conf` from this repo to `/etc/asterisk/extensions_custom.conf`.
   - In `[from-internal-custom]`, list your own extensions (one line each).
   - If your trunk has a channel limit, set `OUT_1` to the value used in `[from-trunk-sip-YOURTRUNK]` in `extensions_additional.conf`.
3. Upload two recordings in **PBX → System Recordings** (wav, 8 kHz, mono), named `callback-prompt` and `campon-prompt`. Camp-on stays off until `campon-prompt` exists.
4. Run `asterisk -rx "dialplan reload"`.
5. For feature 1 only: in the trunk's **PEER Details** add `context=from-trunk-callback` and Apply. To undo, remove that line.

## Limits / محدودیت‌ها

- chan_sip only (`SIP/` channels, device name equal to extension number). Not written for PJSIP.
- Callback lookup matches the last 10 digits of the caller ID, which suits Iranian numbering; adjust `lastcaller.sh` for other plans.
- The camp-on extension list is static.
- If an extension's voicemail answers before the 20 s callback ring ends, the caller lands in voicemail instead of the IVR.
- Pressing 1 several times queues several camp-on requests.

## License

MIT
