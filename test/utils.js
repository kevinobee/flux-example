import { sleep } from 'k6';

export const THINK_TIME = 0.1;

export function ThinkTime( multiplier = 1) {
    sleep(THINK_TIME * multiplier);
}