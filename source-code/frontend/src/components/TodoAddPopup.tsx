import { FormEvent, useState } from 'react';
import { TodoForm } from '../interfaces/todoInterface';

interface TodoFormAddPopupProps {
  showPopup: boolean;
  setShowPopup: (show: boolean) => void;
  addTodo: (todo: TodoForm) => void;
}

const TodoFormAddPopup: React.FC<TodoFormAddPopupProps> = ({ showPopup, setShowPopup, addTodo }) => {
  const [newTodo, setNewTodo] = useState<TodoForm>({
    title: '',
    description: '',
    completed: false,
  });

  const handleAddTodo = (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    addTodo(newTodo);
    setShowPopup(false);
    setNewTodo({
      title: '',
      description: '',
      completed: false,
    });
  };

  return (
    showPopup && (
      <div className='fixed inset-0 flex items-center justify-center bg-black bg-opacity-50'>
        <div className='bg-white p-8 rounded-md shadow-md'>
          <h2 className='text-2xl font-bold mb-4'>Add Todo</h2>
          <form onSubmit={handleAddTodo}>
            <div className='mb-4'>
              <label htmlFor='title' className='block text-sm font-bold mb-2'>
                Title:
              </label>
              <input
                type='text'
                id='title'
                value={newTodo.title}
                onChange={(e) => setNewTodo({ ...newTodo, title: e.target.value })}
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
                value={newTodo.description}
                onChange={(e) => setNewTodo({ ...newTodo, description: e.target.value })}
                className='w-full border border-gray-300 rounded-md px-3 py-2'
              />
            </div>
            <button
              type='submit'
              className='bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 shadow-sm'
            >
              Add Todo
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

export default TodoFormAddPopup;
