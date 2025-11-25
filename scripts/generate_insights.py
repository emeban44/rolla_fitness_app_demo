#!/usr/bin/env python3
import json
import random
from datetime import datetime

# Load the JSON data
with open('assets/data/scores_data.json', 'r') as f:
    data = json.load(f)

# Extract all unique dates from daily_metrics
dates = set()
for score_type in ['health', 'readiness', 'activity']:
    for entry in data['daily_metrics'][score_type]:
        dates.add(entry['date'])

dates = sorted(list(dates))

# Insight templates for each score type
health_insights = [
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
]

readiness_insights = [
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
]

activity_insights = [
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
]

# Helper functions to fill in placeholders
def fill_health_insight(template, score):
    text, itype = template
    states = ["looking good", "well-balanced", "on track", "improving", "stable"]
    trends = ["trending up", "improving", "steady", "holding steady", "slightly up"]
    directions = ["positively", "upward", "in the right direction", "steadily"]

    text = text.format(
        state=random.choice(states),
        trend=random.choice(trends),
        direction=random.choice(directions)
    )
    return text, itype

def fill_readiness_insight(template, score):
    text, itype = template
    states = ["elevated", "strong", "within normal range", "optimal", "good"]
    conditions = ["good recovery", "you're well-rested", "strong readiness", "excellent preparation"]
    positions = ["above", "near", "at", "slightly above"]
    messages = ["great sign", "looking good", "your body is ready", "excellent"]
    qualities = ["optimal", "sufficient", "good", "excellent", "adequate"]

    text = text.format(
        state=random.choice(states),
        condition=random.choice(conditions),
        position=random.choice(positions),
        message=random.choice(messages),
        quality=random.choice(qualities)
    )
    return text, itype

def fill_activity_insight(template, score):
    text, itype = template
    trends = ["trending up", "improving", "increasing", "on the rise"]
    states = ["solid", "strong", "good", "excellent", "impressive"]
    qualities = ["good", "strong", "healthy", "solid", "excellent"]
    comparisons = ["approaching", "meeting", "exceeding", "on track with"]
    positions = ["good", "strong", "healthy", "solid"]
    messages = ["keep it up", "great work", "you're doing well", "nice job"]

    text = text.format(
        trend=random.choice(trends),
        state=random.choice(states),
        quality=random.choice(qualities),
        comparison=random.choice(comparisons),
        position=random.choice(positions),
        message=random.choice(messages)
    )
    return text, itype

# Generate insights for each date
new_insights = {
    "health": {},
    "readiness": {},
    "activity": {}
}

for date in dates:
    # Get scores for this date to make insights more contextual
    health_score = None
    readiness_score = None
    activity_score = None

    for entry in data['daily_metrics']['health']:
        if entry['date'] == date:
            health_score = entry.get('score')
            break

    for entry in data['daily_metrics']['readiness']:
        if entry['date'] == date:
            readiness_score = entry.get('score')
            break

    for entry in data['daily_metrics']['activity']:
        if entry['date'] == date:
            activity_score = entry.get('score')
            break

    # Generate health insight
    if health_score:
        template = random.choice(health_insights)
        text, itype = fill_health_insight(template, health_score)
        new_insights['health'][date] = {
            "id": f"h_{date}",
            "text": text,
            "type": itype
        }

    # Generate readiness insight
    if readiness_score:
        template = random.choice(readiness_insights)
        text, itype = fill_readiness_insight(template, readiness_score)
        new_insights['readiness'][date] = {
            "id": f"r_{date}",
            "text": text,
            "type": itype
        }

    # Generate activity insight
    if activity_score:
        template = random.choice(activity_insights)
        text, itype = fill_activity_insight(template, activity_score)
        new_insights['activity'][date] = {
            "id": f"a_{date}",
            "text": text,
            "type": itype
        }

# Update the data with new insights
data['insights'] = new_insights

# Write back to file
with open('assets/data/scores_data.json', 'w') as f:
    json.dump(data, f, indent=2)

print(f"Generated insights for {len(dates)} dates!")
print(f"Total insights: {len(new_insights['health']) + len(new_insights['readiness']) + len(new_insights['activity'])}")
