package com.example.todolist.controller;

import com.example.todolist.service.TaskService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/")
public class TaskController {

    private final TaskService taskService;

    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    @GetMapping
    public String index(Model model) {
        model.addAttribute("tasks", taskService.getAllTasks());
        return "index";
    }

    @PostMapping("/add")
    public String addTask(@RequestParam String title, RedirectAttributes redirectAttributes) {
        if (taskService.addTask(title)) {
            redirectAttributes.addFlashAttribute("message", "Task added.");
        } else {
            redirectAttributes.addFlashAttribute("error", "Task title cannot be empty.");
        }
        return "redirect:/";
    }

    @PostMapping("/delete/{id}")
    public String deleteTask(@PathVariable int id, RedirectAttributes redirectAttributes) {
        if (taskService.deleteTask(id)) {
            redirectAttributes.addFlashAttribute("message", "Task deleted.");
        } else {
            redirectAttributes.addFlashAttribute("error", "Task not found.");
        }
        return "redirect:/";
    }

    @PostMapping("/complete/{id}")
    public String completeTask(@PathVariable int id, RedirectAttributes redirectAttributes) {
        if (taskService.completeTask(id)) {
            redirectAttributes.addFlashAttribute("message", "Task marked as completed.");
        } else {
            redirectAttributes.addFlashAttribute("error", "Task not found.");
        }
        return "redirect:/";
    }
}
