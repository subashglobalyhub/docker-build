import React from 'react';

interface Props {
  onDeleteConfirmed: () => void;
  onCancel: () => void;
}

const DeleteConfirmationPopup: React.FC<Props> = ({ onDeleteConfirmed, onCancel }) => {
  return (
    <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
      <div className="bg-white p-8 rounded-md shadow-md">
        <p className="text-lg mb-4">Are you sure you want to delete this todo?</p>
        <div className="flex justify-end">
          <button className="mr-2 bg-red-500 text-white px-4 py-2 rounded-md hover:bg-red-600" onClick={onDeleteConfirmed}>
            Delete
          </button>
          <button className="bg-gray-500 text-white px-4 py-2 rounded-md hover:bg-gray-600" onClick={onCancel}>
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
};

export default DeleteConfirmationPopup;
