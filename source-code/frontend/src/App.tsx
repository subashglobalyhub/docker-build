import { useEffect, useState } from 'react';
import { getAllTodos, createTodo, deleteTodo, updateTodo } from './axios/requests';
import { Todo, TodoForm } from './interfaces/todoInterface';
import TodoFormAddPopup from './components/TodoAddPopup';
import TodoUpdatePopup from './components/TodoUpdatePopup';
import DeleteConfirmationPopup from './components/DeleteConfirmationPopup';
import { PlusIcon } from 'lucide-react';

function App() {
  const [todos, setTodos] = useState<Todo[]>([]);
  const [showAddPopup, setShowAddPopup] = useState(false);
  const [showUpdatePopup, setShowUpdatePopup] = useState(false);
  const [todoToUpdate, setTodoToUpdate] = useState<Todo | null>(null);
  const [showDeleteConfirmation, setShowDeleteConfirmation] = useState(false);
  const [todoToDelete, setTodoToDelete] = useState<Todo | null>(null);

  useEffect(() => {
    const fetchTodos = async () => {
      try {
        const data = await getAllTodos();
        setTodos(data);
      } catch (error) {
        console.error('Error fetching todos:', error);
      }
    };

    fetchTodos();
  }, []);

  const handleAddTodo = async (todo: TodoForm) => {
    try {
      const addedTodo = await createTodo(todo);
      setTodos(prevTodos => [...prevTodos, addedTodo]);
      setShowAddPopup(false);
    } catch (error) {
      console.error('Error adding todo:', error);
    }
  };

  const handleEditTodo = (todo: Todo) => {
    setTodoToUpdate(todo);
    setShowUpdatePopup(true);
  };

  const handleUpdateTodo = async (updatedTodo: TodoForm) => {
    if (!todoToUpdate) return;
  
    try {
      await updateTodo(todoToUpdate.id, updatedTodo);
      const updatedTodos = todos.map(todo => (todo.id === todoToUpdate.id ? { ...updatedTodo, id: todo.id } : todo));
      setTodos(updatedTodos);
      setShowUpdatePopup(false);
      setTodoToUpdate(null);
    } catch (error) {
      console.error('Error updating todo:', error);
    }
  };

  const handleDeleteTodo = async (id: number) => {
    try {
      await deleteTodo(id);
      setTodos(prevTodos => prevTodos.filter(todo => todo.id !== id));
      setShowDeleteConfirmation(false);
    } catch (error) {
      console.error('Error deleting todo:', error);
    }
  };

  const confirmDelete = (todo: Todo) => {
    setTodoToDelete(todo);
    setShowDeleteConfirmation(true);
  };

  const cancelDelete = () => {
    setShowDeleteConfirmation(false);
    setTodoToDelete(null);
  };

  return (
    <div className='w-full min-h-screen bg-gray-200 pt-16 px-8'>
      <div className='flex justify-between items-center mb-10'>
        <h1 className='text-4xl font-bold'>TODO List</h1>
        <button
          className='bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 shadow-sm'
          onClick={() => setShowAddPopup(true)}
        >
          <PlusIcon />
        </button>
      </div>
      <div className='grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6'>
        {todos.map(todo => (
          <div key={todo.id} className={'bg-white p-4 rounded-md shadow-md flex flex-col'}>
            <div>
              <h2 className='text-xl font-bold'>{todo.title}</h2>
              <p className='text-gray-600'>{todo.description}</p>
            </div>
            <div className='flex-grow' />
            <p className={`${todo.completed ? 'text-green-500' : 'text-red-500'} font-bold mb-4`}>
              {todo.completed ? 'Completed' : 'Not Completed'}
            </p>
            <div className='flex justify-between'>
              <button
                className='bg-green-500 text-white px-4 py-2 rounded-md hover:bg-green-600'
                onClick={() => handleEditTodo(todo)}
              >
                Edit
              </button>
              <button
                className='bg-red-500 text-white px-4 py-2 rounded-md hover:bg-red-600'
                onClick={() => confirmDelete(todo)}
              >
                Delete
              </button>
            </div>
          </div>
        ))}
      </div>
      <TodoUpdatePopup
        showPopup={showUpdatePopup}
        setShowPopup={setShowUpdatePopup}
        updateTodo={handleUpdateTodo}
        todoToUpdate={todoToUpdate}
      />
      <TodoFormAddPopup showPopup={showAddPopup} setShowPopup={setShowAddPopup} addTodo={handleAddTodo} />
      {showDeleteConfirmation && (
        <DeleteConfirmationPopup
          onDeleteConfirmed={() => handleDeleteTodo(todoToDelete!.id)}
          onCancel={cancelDelete}
        />
      )}
    </div>
  );
}

export default App;
