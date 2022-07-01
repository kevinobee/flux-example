import http from 'k6/http';
import { check } from 'k6';

import { ThinkTime } from '../../utils.js';

export function checkLitmusChaos() {
    const res = http.get('http://localhost:9091/', {tags: {name: '03_Litmus_Chaos_Homepage'}});

    check(res, {
      'is status 200': (r) => r.status === 200,
      '03_text verification': (r) =>
        r.body.includes('ChaosCenter'),
     });

   ThinkTime();
}
