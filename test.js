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
  checkServiceMesh();
  checkMonitoring()
  checkApplications();
  checkTools();

  sleep(1);
}

function checkApplications() {
  checkEmojiVotoApp();
}

function checkServiceMesh() {
  checkLinkerdDashboard();
  checkLinkerdGrafanaDashboard();
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
    'Litmus Chaos homepage returns status code 200': (r) => r.status === 200,
    'Litmus Chaos homepage returns expected text': (r) =>
      r.body.includes('ChaosCenter'),
   });
}

function checkLinkerdDashboard() {
  const res = http.get('http://localhost:8084');

  check(res, {
    'Linkerd Dashboard returns status code 200': (r) => r.status === 200,
    'Linkerd Dashboard returns expected text': (r) =>
      r.body.includes('Linkerd'),
   });
}

function checkLinkerdGrafanaDashboard() {
  const res = http.get('http://localhost:8084/grafana');

  check(res, {
    'Linkerd Grafana Dashboard returns status code 200': (r) => r.status === 200,
    'Linkerd Grafana Dashboard returns expected text': (r) =>
      r.body.includes('Grafana'),
   });
}

function checkMonitoring() {
  checkFluxClusterStats();
  checkFluxControlPlane();
}

function checkFluxClusterStats() {
  const res = http.get('http://localhost:3000/d/flux-cluster/flux-cluster-stats');

  check(res, {
    'Flux Control Statistics monitoring returns status code 200': (r) => r.status === 200,
    'Flux Control Statistics monitoring returns expected text': (r) =>
      r.body.includes('Grafana'),
   });
}

function checkFluxControlPlane() {
  const res = http.get('http://localhost:3000/d/flux-control-plane');

  check(res, {
    'Flux Control Plane monitoring returns status code 200': (r) => r.status === 200,
    'Flux Control Plane monitoring returns expected text': (r) =>
      r.body.includes('Grafana'),
   });
}
