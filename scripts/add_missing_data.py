#!/usr/bin/env python3
import json
import random

# Load the JSON data
with open('assets/data/scores_data.json', 'r') as f:
    data = json.load(f)

# Process daily_metrics to add missing data on every 10th day
for score_type in ['health', 'readiness', 'activity']:
    daily_data = data['daily_metrics'][score_type]

    for entry in daily_data:
        date = entry['date']
        # Get the day number from the date (e.g., "2025-06-10" -> 10)
        day = int(date.split('-')[2])

        # Every 10th day (10, 20, 30), randomly set one metric's score to null
        if day % 10 == 0:
            metrics = entry.get('metrics', {})
            if metrics:
                # Get list of metric keys
                metric_keys = list(metrics.keys())

                # Randomly select one metric to set score to null
                metric_to_nullify = random.choice(metric_keys)

                # Set the score to null (keep title and value)
                metrics[metric_to_nullify]['score'] = None

                print(f"Set score to null for '{metric_to_nullify}' in {score_type} on {date}")

# Write back to file
with open('assets/data/scores_data.json', 'w') as f:
    json.dump(data, f, indent=2)

print("\nDone! Set some metric scores to null on every 10th day.")
