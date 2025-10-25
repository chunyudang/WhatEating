import './ActionButton.css';

function ActionButton({ onClick, disabled, loading }) {
  return (
    <div className="action-button-container">
      <button
        className={`action-button ${loading ? 'loading' : ''}`}
        onClick={onClick}
        disabled={disabled || loading}
      >
        {loading ? '思考中...' : '告诉我！'}
      </button>
    </div>
  );
}

export default ActionButton;
