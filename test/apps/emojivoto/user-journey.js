import http from 'k6/http';
import { check } from 'k6';

import { ThinkTime } from '../../utils.js';

export function checkEmojiVotoApp() {
    const res = http.get('http://localhost:8080', { tags: { name: '01_Emoji_App_Homepage' } });

    check(res, {
        'is status 200': (r) => r.status === 200,
        '01_text verification': (r) =>
            r.body.includes('Emoji Vote'),
    });

   ThinkTime();
}