#!/usr/bin/env python3
"""
Complete data generation script for Rolla Fitness App
Generates 6 months of realistic fitness data from today going backwards
Ensures the project is time-independent and always has fresh data

Features:
- Generates 6 months of daily data
- Realistic score variations (0-100) with trends and patterns
- Handles missing data: null scores for "N/A" display and null metrics for "No data"
- Time-independent: always generates from today
"""
import json
import random
from datetime import datetime, timedelta
import math

def generate_dates(months=6):
    """Generate list of dates from today going back 'months' months"""
    today = datetime.now()
    dates = []

    # Calculate total days (approximately months * 30)
    total_days = months * 30

    for i in range(total_days):
        date = today - timedelta(days=i)
        dates.append(date.strftime("%Y-%m-%d"))

    return sorted(dates)  # Return chronologically (oldest first)

def generate_score_with_trend(base_score, day_index, total_days, variance=15):
    """
    Generate a score that has realistic variance and slight trends
    base_score: average score (0-100)
    day_index: which day in the sequence
    variance: how much the score can vary
    """
    # Add slight upward trend over time (improvement)
    trend = (day_index / total_days) * 10

    # Add some sinusoidal variation (weekly patterns)
    weekly_pattern = math.sin(day_index / 7 * 2 * math.pi) * 8

    # Random daily variance
    daily_variance = random.uniform(-variance, variance)

    score = base_score + trend + weekly_pattern + daily_variance

    # Clamp to 0-100
    return max(0, min(100, int(score)))

def generate_metric_value(metric_type, score):
    """Generate realistic metric values based on score"""

    # Sleep metrics (8-9h is good)
    if metric_type == "sleep":
        hours = 6 + (score / 100) * 3  # 6-9 hours
        minutes = random.randint(0, 59)
        return f"{int(hours)}h {minutes}min"

    # Resting heart rate (lower is better, 50-70 range)
    elif metric_type == "resting_hr":
        hr = 70 - (score / 100) * 20  # 70-50 bpm
        return f"{int(hr)} bpm"

    # HRV (higher is better, 20-60 range)
    elif metric_type == "hrv":
        hrv = 20 + (score / 100) * 40  # 20-60 ms
        return f"{int(hrv)} ms"

    # Active points
    elif metric_type == "active_points":
        points = int((score / 100) * 100)  # 0-100 pts
        return f"{points} pts"

    # Steps
    elif metric_type == "steps":
        steps = int(2000 + (score / 100) * 8000)  # 2000-10000 steps
        return f"{steps}"

    # Move hours
    elif metric_type == "move_hours":
        hours = int(3 + (score / 100) * 9)  # 3-12 hours
        return f"{hours} h"

    return "N/A"

# Insight templates for each score type
INSIGHT_TEMPLATES = {
    "health": [
        ("Your balance between rest and activity is {state}.", "info"),
        ("Health score is {trend} compared to your weekly average.", "info"),
        ("Great harmony between your Readiness and Activity today.", "info"),
        ("Your body is finding a good rhythm this week.", "info"),
        ("Consider balancing today's activity with adequate recovery.", "suggestion"),
        ("Your overall wellness is trending {direction}.", "info"),
        ("Nice balance! Keep this momentum going.", "info"),
        ("Your health metrics show consistent improvement.", "info"),
        ("Today's score reflects good lifestyle choices.", "info"),
        ("Your body is adapting well to your routine.", "info"),
    ],
    "readiness": [
        ("Excellent sleep quality! Your body recovered well overnight.", "info"),
        ("Your HRV is {state} today, indicating {condition}.", "info"),
        ("Resting heart rate is {position} your baseline - {message}.", "info"),
        ("Your recovery metrics look strong today.", "info"),
        ("Sleep duration was {quality}, giving your body time to recover.", "info"),
        ("Your body shows signs of good recovery today.", "info"),
        ("HRV suggests you're well-prepared for physical activity.", "info"),
        ("Consider an earlier bedtime to boost tomorrow's readiness.", "suggestion"),
        ("Your overnight metrics indicate deep, restorative sleep.", "info"),
        ("Recovery is on track - your body is adapting well.", "info"),
        ("Resting HR is elevated - your body may need more recovery.", "warning"),
        ("HRV is lower than usual. Consider taking it easier today.", "warning"),
    ],
    "activity": [
        ("You're building great momentum with your activity today.", "info"),
        ("Your step count is {trend} - keep up the movement!", "info"),
        ("Great work staying active throughout the day.", "info"),
        ("Move hours are {state}, showing consistent activity.", "info"),
        ("Active points reflect a {quality} level of effort today.", "info"),
        ("Try adding some movement to boost your activity score.", "suggestion"),
        ("You're {comparison} your daily activity goals.", "info"),
        ("Consistent movement today! Your body will thank you.", "info"),
        ("Activity level is {position} - {message}.", "info"),
        ("Great job breaking up sedentary time today.", "info"),
        ("Consider a short walk to increase your move hours.", "suggestion"),
        ("Your activity pattern shows healthy variety.", "info"),
    ],
}

def fill_insight_template(template):
    """Fill insight template with random variations"""
    text, itype = template

    replacements = {
        "state": random.choice(["looking good", "well-balanced", "on track", "improving", "stable"]),
        "trend": random.choice(["trending up", "improving", "steady", "holding steady"]),
        "direction": random.choice(["positively", "upward", "in the right direction"]),
        "condition": random.choice(["good recovery", "you're well-rested", "strong readiness"]),
        "position": random.choice(["above", "near", "at", "slightly above"]),
        "message": random.choice(["great sign", "looking good", "your body is ready"]),
        "quality": random.choice(["optimal", "sufficient", "good", "excellent"]),
        "comparison": random.choice(["approaching", "meeting", "exceeding", "on track with"]),
    }

    for key, value in replacements.items():
        if f"{{{key}}}" in text:
            text = text.replace(f"{{{key}}}", value)

    return text, itype

def generate_complete_data():
    """Generate complete fitness data for 6 months"""
    print("🚀 Starting data generation...")
    print(f"📅 Generating data from {datetime.now().strftime('%Y-%m-%d')} going back 6 months...")

    dates = generate_dates(months=6)
    total_days = len(dates)

    print(f"📊 Generating data for {total_days} days...")

    # Initialize data structure
    data = {
        "scores": {
            "health": {"current_value": 0, "metrics": {}},
            "readiness": {"current_value": 0, "metrics": {}},
            "activity": {"current_value": 0, "metrics": {}},
        },
        "history": {
            "health": [],
            "readiness": [],
            "activity": [],
        },
        "daily_metrics": {
            "health": [],
            "readiness": [],
            "activity": [],
        },
        "insights": {
            "health": {},
            "readiness": {},
            "activity": {},
        },
    }

    # Base scores for each type
    base_scores = {
        "health": 65,
        "readiness": 70,
        "activity": 60,
    }

    # Generate data for each date
    for day_index, date in enumerate(dates):
        # Generate scores for this day
        health_score = generate_score_with_trend(base_scores["health"], day_index, total_days)
        readiness_score = generate_score_with_trend(base_scores["readiness"], day_index, total_days)
        activity_score = generate_score_with_trend(base_scores["activity"], day_index, total_days)

        # Check if we should add missing data (every 10th day)
        day_num = int(date.split('-')[2])
        is_tenth_day = (day_num % 10 == 0)

        # Occasionally set overall score to null (very rare - 2% chance)
        # This makes the RadialGauge show "N/A"
        if random.random() < 0.02:
            health_score = None
        if random.random() < 0.02:
            readiness_score = None
        if random.random() < 0.02:
            activity_score = None

        # Add to history (use 0 for null scores in history)
        data["history"]["health"].append({
            "date": date,
            "value": health_score if health_score is not None else 0
        })
        data["history"]["readiness"].append({
            "date": date,
            "value": readiness_score if readiness_score is not None else 0
        })
        data["history"]["activity"].append({
            "date": date,
            "value": activity_score if activity_score is not None else 0
        })

        # === HEALTH METRICS ===
        health_metrics = {}

        # Health score is derived from readiness and activity
        readiness_metric_score = readiness_score + random.randint(-5, 5) if readiness_score else None
        if readiness_metric_score:
            readiness_metric_score = max(0, min(100, readiness_metric_score))

        activity_metric_score = activity_score + random.randint(-5, 5) if activity_score else None
        if activity_metric_score:
            activity_metric_score = max(0, min(100, activity_metric_score))

        # On 10th days, randomly nullify one metric (30% chance)
        if is_tenth_day and random.random() < 0.3:
            if random.choice([True, False]):
                readiness_metric_score = None
            else:
                activity_metric_score = None

        health_metrics["readiness"] = {
            "title": "Readiness",
            "value": str(readiness_metric_score) if readiness_metric_score is not None else "N/A",
            "score": readiness_metric_score,
        }
        health_metrics["activity"] = {
            "title": "Activity",
            "value": str(activity_metric_score) if activity_metric_score is not None else "N/A",
            "score": activity_metric_score,
        }

        data["daily_metrics"]["health"].append({
            "date": date,
            "score": health_score,
            "metrics": health_metrics,
        })

        # === READINESS METRICS ===
        readiness_metrics = {}

        for metric_type in ["sleep", "resting_hr", "hrv"]:
            if readiness_score is not None:
                base_metric_score = readiness_score + random.randint(-10, 10)
                base_metric_score = max(0, min(100, base_metric_score))

                # On 10th days, randomly nullify this metric (30% chance per metric)
                if is_tenth_day and random.random() < 0.3:
                    metric_score = None
                    metric_value = "N/A"
                else:
                    metric_score = base_metric_score
                    metric_value = generate_metric_value(metric_type, base_metric_score)
            else:
                metric_score = None
                metric_value = "N/A"

            # Format title nicely
            title_map = {
                "sleep": "Sleep",
                "resting_hr": "Resting HR",
                "hrv": "Overnight HRV"
            }

            readiness_metrics[metric_type] = {
                "title": title_map.get(metric_type, metric_type.replace("_", " ").title()),
                "value": metric_value,
                "score": metric_score,
            }

        data["daily_metrics"]["readiness"].append({
            "date": date,
            "score": readiness_score,
            "metrics": readiness_metrics,
        })

        # === ACTIVITY METRICS ===
        activity_metrics = {}

        for metric_type in ["active_points", "steps", "move_hours"]:
            if activity_score is not None:
                base_metric_score = activity_score + random.randint(-10, 10)
                base_metric_score = max(0, min(100, base_metric_score))

                # On 10th days, randomly nullify this metric (30% chance per metric)
                if is_tenth_day and random.random() < 0.3:
                    metric_score = None
                    metric_value = "N/A"
                else:
                    metric_score = base_metric_score
                    metric_value = generate_metric_value(metric_type, base_metric_score)
            else:
                metric_score = None
                metric_value = "N/A"

            # Format title nicely
            title_map = {
                "active_points": "Active points",
                "steps": "Steps",
                "move_hours": "Move hours"
            }

            activity_metrics[metric_type] = {
                "title": title_map.get(metric_type, metric_type.replace("_", " ").title()),
                "value": metric_value,
                "score": metric_score,
            }

        data["daily_metrics"]["activity"].append({
            "date": date,
            "score": activity_score,
            "metrics": activity_metrics,
        })

        # === GENERATE INSIGHTS ===
        for score_type in ["health", "readiness", "activity"]:
            template = random.choice(INSIGHT_TEMPLATES[score_type])
            text, itype = fill_insight_template(template)

            data["insights"][score_type][date] = {
                "id": f"{score_type[0]}_{date}",
                "text": text,
                "type": itype,
            }

    # Set current scores (most recent date = today)
    most_recent = dates[-1]

    # Find current scores from daily_metrics
    for entry in data["daily_metrics"]["health"]:
        if entry["date"] == most_recent:
            data["scores"]["health"]["current_value"] = entry["score"]
            data["scores"]["health"]["metrics"] = entry["metrics"]
            break

    for entry in data["daily_metrics"]["readiness"]:
        if entry["date"] == most_recent:
            data["scores"]["readiness"]["current_value"] = entry["score"]
            data["scores"]["readiness"]["metrics"] = entry["metrics"]
            break

    for entry in data["daily_metrics"]["activity"]:
        if entry["date"] == most_recent:
            data["scores"]["activity"]["current_value"] = entry["score"]
            data["scores"]["activity"]["metrics"] = entry["metrics"]
            break

    print(f"✅ Generated {total_days} days of data")
    print(f"📈 Health: {data['scores']['health']['current_value']}")
    print(f"💪 Readiness: {data['scores']['readiness']['current_value']}")
    print(f"🏃 Activity: {data['scores']['activity']['current_value']}")

    return data

def main():
    """Main execution function"""
    try:
        # Generate data
        data = generate_complete_data()

        # Write to file
        output_path = "assets/data/scores_data.json"

        print(f"\n💾 Writing to {output_path}...")
        with open(output_path, 'w') as f:
            json.dump(data, f, indent=2)

        print("✨ Data generation complete!")
        print(f"🎉 Successfully generated 6 months of fitness data!")
        print(f"📅 Data range: {datetime.now() - timedelta(days=180)} to {datetime.now()}")

    except Exception as e:
        print(f"❌ Error generating data: {e}")
        import traceback
        traceback.print_exc()
        exit(1)

if __name__ == "__main__":
    main()
