// 1️⃣ Check humidity level
export function checkHumidityLevel(humidity) {
  if (humidity > 70) {
    throw new Error('Humidity too high!');
  }
}

// 2️⃣ Custom errors for temperature monitoring
export class ArgumentError extends Error {}

export class OverheatingError extends Error {
  constructor(temperature) {
    super(`Machine overheating at ${temperature}°C`);
    this.temperature = temperature;
  }
}

// 2️⃣ Function to report overheating
export function reportOverheating(temperature) {
  if (temperature === null) {
    throw new ArgumentError('Sensor is broken');
  }

  if (temperature > 500) {
    throw new OverheatingError(temperature);
  }
}

// 3️⃣ Monitor the machine and react to errors
export function monitorTheMachine(actions) {
  try {
    actions.check();
  } catch (error) {
    if (error instanceof ArgumentError) {
      // Sensor broken → alert technician
      actions.alertDeadSensor();
    } else if (error instanceof OverheatingError) {
      // Overheating protocol
      if (error.temperature <= 600) {
        actions.alertOverheating();
      } else {
        actions.shutdown();
      }
    } else {
      // Unknown error → rethrow
      throw error;
    }
  }
}
