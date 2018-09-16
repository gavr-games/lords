package ai.pathfinding;

import ai.game.board.BoardCell;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

public class Path implements Comparable<Path> {
	private int distance;
	private BoardCell cell;
	private List<Path> previousSteps;

	public Path(int additionalDistance, BoardCell cell, Path previousStep) {
		this.distance = additionalDistance + (previousStep == null ? 0 : previousStep.distance);
		this.cell = cell;
		previousSteps = new ArrayList<>();
		if (previousStep != null) {
			previousSteps.add(previousStep);
		}
	}

	public int getDistance() {
		return distance;
	}

	public List<Path> getPreviousSteps() {
		return previousSteps;
	}

	public BoardCell getCell() {
		return cell;
	}

	public Path getRandomPreviousStep() {
		if (previousSteps.isEmpty()) {
			return null;
		}
		return previousSteps.get(ThreadLocalRandom.current().nextInt(previousSteps.size()));
	}

	@Override
	public int compareTo(Path otherPath) {
		return Integer.compare(distance, otherPath.getDistance());
	}
}
