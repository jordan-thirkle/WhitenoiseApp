import { test, describe, beforeEach, afterEach, mock } from 'node:test';
import * as assert from 'node:assert/strict';
import { showToast, toastMessage } from './store.ts';

describe('showToast', () => {
  beforeEach(() => {
    mock.timers.enable({ apis: ['setTimeout', 'Date'] });
    toastMessage.set(null); // Reset the store before each test
  });

  afterEach(() => {
    mock.timers.reset();
  });

  test('should set the toast message with default type info', () => {
    showToast('Hello world');

    const state = toastMessage.get();
    assert.ok(state !== null);
    assert.equal(state.message, 'Hello world');
    assert.equal(state.type, 'info');
    assert.ok(typeof state.id === 'number');
  });

  test('should set the toast message with specified type', () => {
    showToast('Success!', 'success');

    const state = toastMessage.get();
    assert.ok(state !== null);
    assert.equal(state.message, 'Success!');
    assert.equal(state.type, 'success');
    assert.ok(typeof state.id === 'number');
  });

  test('should auto-clear the toast after 3 seconds', () => {
    showToast('Auto clear me');

    // Initially set
    assert.ok(toastMessage.get() !== null);

    // Advance time by 2.9 seconds
    mock.timers.tick(2900);
    assert.ok(toastMessage.get() !== null);

    // Advance time by 0.1 seconds (total 3 seconds)
    mock.timers.tick(100);
    assert.equal(toastMessage.get(), null);
  });
});
