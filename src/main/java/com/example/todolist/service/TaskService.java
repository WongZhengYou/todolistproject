package com.example.todolist.service;

import com.example.todolist.model.Task;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Service
public class TaskService {
    private final List<Task> tasks = new ArrayList<>();
    private final AtomicInteger idGenerator = new AtomicInteger();

    public TaskService() {
        addTask("Finish project setup");
        addTask("Add a new task");
        completeTask(1);
    }

    public synchronized List<Task> getAllTasks() {
        return tasks.stream()
            .sorted(Comparator.comparing(Task::isCompleted).thenComparing(Task::getId))
            .collect(Collectors.toList());
    }

    public synchronized boolean addTask(String title) {
        String normalizedTitle = title == null ? "" : title.trim();
        if (normalizedTitle.isEmpty()) {
            return false;
        }

        tasks.add(new Task(idGenerator.incrementAndGet(), normalizedTitle));
        return true;
    }

    public synchronized boolean deleteTask(int id) {
        return tasks.removeIf(task -> task.getId() == id);
    }

    public synchronized boolean completeTask(int id) {
        for (Task task : tasks) {
            if (task.getId() == id) {
                task.setCompleted(true);
                return true;
            }
        }
        return false;
    }
}
