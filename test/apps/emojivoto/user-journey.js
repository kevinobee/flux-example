import http from 'k6/http';
import { check, group } from 'k6'
import { Trend } from 'k6/metrics'

import { ThinkTime } from '../../utils.js';

let HomePageTrend = new Trend('EmojiVoto Get homepage', true);
let LeaderboardPageTrend = new Trend('EmojiVoto Get leaderboard', true);

const baseUrl = __ENV.EMOJIVOTO_URL
    ? `https://${__ENV.EMOJIVOTO_URL}`
    : `http://localhost:8080`;

const endpoints = {
    homepage: `${baseUrl}/`,
    script: `${baseUrl}/js`,
    listApi: `${baseUrl}/api/list`,
    favicon: `${baseUrl}/img/favicon.ico`,
    leaderboard: `${baseUrl}/leaderboard`
}

export function checkEmojiVotoApp() {

    group('Applications: EmojiVoto user journey', () => {

        let responses;

        responses = http.batch([
            ['GET', endpoints.homepage, null, { tags: { ctype: 'html' } }],
            ['GET', endpoints.listApi, null, { tags: { ctype: 'json' } }],
            ['GET', endpoints.script, null, { tags: { ctype: 'js' } }],
            ['GET', endpoints.favicon, null, { tags: { ctype: 'images' } }],
        ], { tag: { name: 'Get Homepage' } });
        check(responses[0], {
            'status was 200': (res) => res.status === 200,
            'text verification': (res) => res.body.includes('Emoji Vote')
        });

        HomePageTrend.add(responses[0].timings.duration)
        ThinkTime();

        responses = http.batch([
            ['GET', endpoints.leaderboard, null, { tags: { ctype: 'html' } }],
            ['GET', endpoints.favicon, null, { tags: { ctype: 'images' } }],
            ['GET', endpoints.script, null, { tags: { ctype: 'js' } }],
        ], { tag: { name: 'Get Leaderboard' } });
        check(responses[0], {
            'status was 200': (res) => res.status === 200,
            'text verification': (res) => res.body.includes('Emoji Vote')
        });

        LeaderboardPageTrend.add(responses[0].timings.duration)
        ThinkTime();
    })
}