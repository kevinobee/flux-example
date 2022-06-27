import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 1,

  thresholds: {
    http_req_failed: ['rate<=0.05'],
    http_req_duration: ['p(99)<500'], // 99% of requests must complete below 500ms
  },

  ext: {
    loadimpact: {
      projectID: 3589514,
      // Test runs with the same name groups test runs together
      name: "Flux Example: Cluster Services"
    }
  }
};

export default function () {

  // Apps
  checkEmojiVotoApp();

  // Monitoring
  checkGrafana()

  // Tools
  checkLitmusChaos();
}


function checkEmojiVotoApp() {
  const res = http.get('http://localhost:8080', {tags: {name: '01_Emoji_App_Homepage'}});

  check(res, {
    'is status 200': (r) => r.status === 200,
    '01_text verification': (r) =>
      r.body.includes('Emoji Vote'),
   });
}

function checkGrafana() {
  const res = http.get('http://localhost:3000', {tags: {name: '02_Grafana_Homepage'}});

  check(res, {
    'is status 200': (r) => r.status === 200,
    '02_text verification': (r) =>
      r.body.includes('Grafana'),
   });
}

function checkLitmusChaos() {
  const res = http.get('http://localhost:9091/', {tags: {name: '03_Litmus_Chaos_Homepage'}});

  check(res, {
    'is status 200': (r) => r.status === 200,
    '03_text verification': (r) =>
      r.body.includes('ChaosCenter'),
   });
}




