<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>To-Do List</title>
    <style>
        :root {
            --page: #f4efe6;
            --card: #fffdf8;
            --ink: #22201c;
            --muted: #6b655d;
            --line: #d9d0c3;
            --accent: #d97706;
            --accent-dark: #9a3412;
            --success: #3f6212;
            --danger: #b42318;
            --shadow: 0 18px 45px rgba(76, 55, 24, 0.14);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Trebuchet MS", "Segoe UI", sans-serif;
            color: var(--ink);
            background:
                radial-gradient(circle at top left, rgba(217, 119, 6, 0.18), transparent 30%),
                linear-gradient(160deg, #f9f5ee 0%, var(--page) 55%, #ebe0d2 100%);
        }

        .shell {
            width: min(760px, calc(100% - 32px));
            margin: 48px auto;
            padding: 32px;
            border: 1px solid rgba(154, 52, 18, 0.12);
            border-radius: 28px;
            background: rgba(255, 253, 248, 0.92);
            box-shadow: var(--shadow);
            backdrop-filter: blur(6px);
        }

        h1 {
            margin: 0 0 10px;
            font-size: clamp(2rem, 5vw, 3rem);
            line-height: 1;
        }

        .subtitle {
            margin: 0 0 28px;
            color: var(--muted);
        }

        .notice {
            margin-bottom: 18px;
            padding: 12px 14px;
            border-radius: 14px;
            font-size: 0.95rem;
        }

        .notice.success {
            color: var(--success);
            background: rgba(101, 163, 13, 0.12);
        }

        .notice.error {
            color: var(--danger);
            background: rgba(180, 35, 24, 0.1);
        }

        .task-form {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 12px;
            margin-bottom: 28px;
        }

        .task-form input {
            min-width: 0;
            padding: 14px 16px;
            border: 1px solid var(--line);
            border-radius: 16px;
            background: #fff;
            font-size: 1rem;
        }

        .task-form button,
        .action-button {
            border: 0;
            border-radius: 14px;
            padding: 12px 16px;
            font-size: 0.95rem;
            cursor: pointer;
            transition: transform 140ms ease, opacity 140ms ease, background 140ms ease;
        }

        .task-form button {
            background: linear-gradient(135deg, var(--accent), var(--accent-dark));
            color: #fff;
            font-weight: 700;
        }

        .task-form button:hover,
        .action-button:hover {
            transform: translateY(-1px);
        }

        .list {
            display: grid;
            gap: 14px;
        }

        .task-card {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            align-items: center;
            padding: 18px;
            border: 1px solid var(--line);
            border-radius: 20px;
            background: var(--card);
        }

        .task-copy {
            min-width: 0;
        }

        .task-title {
            margin: 0 0 6px;
            font-size: 1.05rem;
            word-break: break-word;
        }

        .task-title.completed {
            color: var(--muted);
            text-decoration: line-through;
        }

        .task-status {
            color: var(--muted);
            font-size: 0.92rem;
        }

        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .action-button.complete {
            background: rgba(63, 98, 18, 0.12);
            color: var(--success);
        }

        .action-button.delete {
            background: rgba(180, 35, 24, 0.1);
            color: var(--danger);
        }

        .empty {
            padding: 28px 20px;
            border: 1px dashed var(--line);
            border-radius: 20px;
            text-align: center;
            color: var(--muted);
            background: rgba(255, 255, 255, 0.55);
        }

        @media (max-width: 640px) {
            .shell {
                margin: 20px auto;
                padding: 22px;
            }

            .task-form {
                grid-template-columns: 1fr;
            }

            .task-card {
                flex-direction: column;
                align-items: stretch;
            }

            .actions {
                justify-content: flex-start;
            }
        }
    </style>
</head>
<body>
<main class="shell">
    <h1>To-Do List</h1>
    <p class="subtitle">Track what matters and keep the day moving.</p>

    <c:if test="${not empty message}">
        <div class="notice success">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="notice error">${error}</div>
    </c:if>

    <form class="task-form" action="${pageContext.request.contextPath}/add" method="post">
        <input type="text" name="title" placeholder="What do you need to get done?" maxlength="120" required>
        <button type="submit">Add Task</button>
    </form>

    <section class="list" aria-label="Tasks">
        <c:choose>
            <c:when test="${empty tasks}">
                <div class="empty">No tasks yet. Add your first one above.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="task" items="${tasks}">
                    <article class="task-card">
                        <div class="task-copy">
                            <p class="task-title ${task.completed ? 'completed' : ''}">${task.title}</p>
                            <div class="task-status">
                                <c:out value="${task.completed ? 'Completed' : 'Pending'}" />
                            </div>
                        </div>
                        <div class="actions">
                            <c:if test="${not task.completed}">
                                <form action="${pageContext.request.contextPath}/complete/${task.id}" method="post">
                                    <button class="action-button complete" type="submit">Complete</button>
                                </form>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/delete/${task.id}" method="post">
                                <button class="action-button delete" type="submit">Delete</button>
                            </form>
                        </div>
                    </article>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </section>
</main>
</body>
</html>
