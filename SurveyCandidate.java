import java.util.ArrayList;
import java.util.Collections;

public class SurveyCandidate implements Comparable<SurveyCandidate> {
    public enum Compatibility {
        STRONG_COMPATIBLE, COMPATIBLE,
        INCOMPATIBLE, STRONG_INCOMPATIBLE
    }

    public static class Issue implements Comparable<Issue> {
        public final String topic;
        public final String position;
        public final Compatibility compatibility;
        public final int weight;

        public Issue (String topic, String position, Compatibility c, int w) {
            this.topic = topic;
            this.position = position;
            this.compatibility = c;
            this.weight = w;
        }

        @Override
        public int compareTo(Issue other) {
            if (this.compatibility == other.compatibility)
                return (this.weight > other.weight) ? -1 : 1;
            switch (this.compatibility) {
                case STRONG_COMPATIBLE:
                    return -1;
                case COMPATIBLE:
                    if (other.compatibility == Compatibility.STRONG_COMPATIBLE)
                        return -1; 
                    else
                        return 1;
                case INCOMPATIBLE:
                    if (other.compatibility == Compatibility.STRONG_INCOMPATIBLE)
                        return 1; 
                    else
                        return -1;
                case STRONG_INCOMPATIBLE:
                    return 1;
                default:
                    return 1;
            }
        }
    }

    public final String first;
    public final String last;
    public int score;
    public final ArrayList<Issue> issues;

    public SurveyCandidate(String first, String last) {
        this.first = first;
        this.last = last;
        score = 0;
        issues = new ArrayList<Issue>();
    }

    public void addIssue(String topic, String candidatePosition, int userScore, int w) {
        Compatibility result = Compatibility.COMPATIBLE;
        switch (userScore) {
            case 1: // User selected "Strongly Disagree"
                switch (candidatePosition) {
                    case "Strongly Agrees":
                    case "Agrees":
                        result = Compatibility.STRONG_INCOMPATIBLE;
                        break;
                    case "Neutral/No opinion":
                        result = Compatibility.INCOMPATIBLE;
                        break;
                    case "Disgrees":
                        result = Compatibility.COMPATIBLE;
                        break;
                    case "Strongly Disagrees":
                        result = Compatibility.STRONG_COMPATIBLE;
                        break;
                }
                break;
            case 2: // User selected "Disagree"
                switch (candidatePosition) {
                    case "Strongly Agrees":
                        result = Compatibility.STRONG_INCOMPATIBLE;
                        break;
                    case "Agrees":
                        result = Compatibility.INCOMPATIBLE;
                        break;
                    case "Neutral/No opinion":
                        result = Compatibility.COMPATIBLE;
                        break;
                    case "Disgrees":
                        result = Compatibility.STRONG_COMPATIBLE;
                        break;
                    case "Strongly Disagrees":
                        result = Compatibility.COMPATIBLE;
                        break;
                }
                break;
            case 3: // User selected "Neutral"
                result = Compatibility.COMPATIBLE;
                break;
            case 4: // User selected "Agree"
                switch (candidatePosition) {
                    case "Strongly Agrees":
                        result = Compatibility.COMPATIBLE;
                        break;
                    case "Agrees":
                        break;
                    case "Neutral/No opinion":
                        result = Compatibility.COMPATIBLE;
                        break;
                    case "Disgrees":
                        result = Compatibility.INCOMPATIBLE;
                        break;
                    case "Strongly Disagrees":
                        result = Compatibility.STRONG_INCOMPATIBLE;
                        break;
                }
                break;
            case 5: // User selected "Strongly Agree"
                switch (candidatePosition) {
                    case "Strongly Agrees":
                        result = Compatibility.STRONG_COMPATIBLE;
                        break;
                    case "Agrees":
                        result = Compatibility.COMPATIBLE;
                        break;
                    case "Neutral/No opinion":
                        result = Compatibility.INCOMPATIBLE;
                        break;
                    case "Disgrees":
                    case "Strongly Disagrees":
                        result = Compatibility.STRONG_INCOMPATIBLE;
                        break;
                }
                break;
            default: // Default to neutral
                result = Compatibility.COMPATIBLE;
                break;
        }
        issues.add(new Issue(topic, candidatePosition, result, w));
    }

    public void scoreAndSort() {
        for (Issue element : issues) {
            int value = 1;
            switch (element.compatibility) {
                case STRONG_COMPATIBLE:
                    value = 2;
                    break;
                case COMPATIBLE:
                    value = 1;
                    break;
                case INCOMPATIBLE:
                    value = -1;
                    break;
                case STRONG_INCOMPATIBLE:
                    value = -2;
                    break;
            }
            score += value * element.weight;
        }
        Collections.sort(issues);
    }

    @Override
    public int compareTo(SurveyCandidate other) {
        if (this.score > other.score)
            return -1;
        else if (this.score < other.score)
            return 1;
        else
            return 0;
    }
}
