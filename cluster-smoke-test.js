import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 1,

  thresholds: {
    http_req_duration: ['p(99)<500'], // 99% of requests must complete below 500ms
  },

  ext: {
    loadimpact: {
      projectID: 3589514,
      // Test runs with the same name groups test runs together
      name: "Cluster Services Test"
    }
  }
};

export default function () {
  checkMonitoring()
  checkApplications();
  checkTools();

  sleep(1);
}

function checkApplications() {
  checkEmojiVotoApp();
}

function checkTools() {
  checkLitmusChaos();
}

function checkEmojiVotoApp() {
  const res = http.get('http://localhost:8080');

  check(res, {
    'Emoji Vote homepage returns status code 200': (r) => r.status === 200,
    'Emoji Vote homepage returns expected text': (r) =>
      r.body.includes('Emoji Vote'),
   });
}

function checkLitmusChaos() {
  const res = http.get('http://localhost:9091/');

  check(res, {
    'Litmus Chaos returns status code 200': (r) => r.status === 200,
    'Litmus Chaos returns expected text': (r) =>
      r.body.includes('ChaosCenter'),
   });
}

function checkMonitoring() {
  checkGrafana();
}

function checkGrafana() {
  const res = http.get('http://localhost:3000');

  check(res, {
    'Grafana returns status code 200': (r) => r.status === 200,
    'Grafana returns expected text': (r) =>
      r.body.includes('Grafana'),
   });
}
