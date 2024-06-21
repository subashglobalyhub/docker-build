import { FormEvent, useState, useEffect } from 'react';
import { TodoForm } from '../interfaces/todoInterface';

interface TodoUpdatePopupProps {
  showPopup: boolean;
  setShowPopup: (show: boolean) => void;
  updateTodo: (todo: TodoForm) => void;
  todoToUpdate: TodoForm | null;
}

const TodoUpdatePopup: React.FC<TodoUpdatePopupProps> = ({ showPopup, setShowPopup, updateTodo, todoToUpdate }) => {
  const [editedTodo, setEditedTodo] = useState<TodoForm>({
    title: '',
    description: '',
    completed: false,
  });

  useEffect(() => {
    if (todoToUpdate) {
      setEditedTodo(todoToUpdate);
    }
  }, [todoToUpdate]);

  const handleUpdateTodo = (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    updateTodo(editedTodo);
    setShowPopup(false);
  };

  return (
    showPopup && (
      <div className='fixed inset-0 flex items-center justify-center bg-black bg-opacity-50'>
        <div className='bg-white p-8 rounded-md shadow-md'>
          <h2 className='text-2xl font-bold mb-4'>Edit Todo</h2>
          <form onSubmit={handleUpdateTodo}>
            <div className='mb-4'>
              <label htmlFor='title' className='block text-sm font-bold mb-2'>
                Title:
              </label>
              <input
                type='text'
                id='title'
                value={editedTodo.title}
                onChange={(e) => setEditedTodo({ ...editedTodo, title: e.target.value })}
                className='w-full border border-gray-300 rounded-md px-3 py-2'
              />
            </div>
            <div className='mb-4'>
              <label htmlFor='description' className='block text-sm font-bold mb-2'>
                description:
              </label>
              <textarea
                rows={5}
                cols={50}
                id='description'
                value={editedTodo.description}
                onChange={(e) => setEditedTodo({ ...editedTodo, description: e.target.value })}
                className='w-full border border-gray-300 rounded-md px-3 py-2'
              />
            </div>
            <div className='mb-4'>
              <label htmlFor='completed' className='block text-sm font-bold mb-2'>
                Completed:
              </label>
              <select
                id='completed'
                value={editedTodo.completed ? 'Yes' : 'No'}
                onChange={(e) => setEditedTodo({ ...editedTodo, completed: e.target.value === 'Yes' })}
                className='w-full border border-gray-300 rounded-md px-3 py-2'
              >
                <option value='Yes'>Yes</option>
                <option value='No'>No</option>
              </select>
            </div>
            <button
              type='submit'
              className='bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 shadow-sm'
            >
              Update Todo
            </button>
            <button
              onClick={() => setShowPopup(false)}
              className='ml-4 bg-gray-300 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-400'
            >
              Cancel
            </button>
          </form>
        </div>
      </div>
    )
  );
};

export default TodoUpdatePopup;
