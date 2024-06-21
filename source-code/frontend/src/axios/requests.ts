import axios from 'axios';
import { Todo, TodoForm } from '../interfaces/todoInterface';

const api = axios.create({
  baseURL: 'http://localhost:3000/todo',
});

export const getAllTodos = async (): Promise<Todo[]> => {
  const response = await api.get('/');
  const todos = response.data.todos;
  return todos.sort((a: Todo, b: Todo) => (a.id > b.id ? 1 : -1));
};

export const getTodoById = async (id: number): Promise<Todo> => {
  const response = await api.get(`/${id}`);
  return response.data.todo;
};

export const createTodo = async (todo: TodoForm): Promise<Todo> => {
  const response = await api.post('/', todo);
  return response.data.todo;
};

export const updateTodo = async (id: number, todo: TodoForm): Promise<TodoForm> => {
  const response = await api.put(`/${id}`, todo);
  return response.data.todo;
};

export const deleteTodo = async (id: number): Promise<void> => {
  await api.delete(`/${id}`);
};