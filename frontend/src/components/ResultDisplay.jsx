import './ResultDisplay.css';

function ResultDisplay({ result, visible, error }) {
  if (!visible) return null;

  if (error) {
    return (
      <div className="result-display error">
        <div className="result-card">
          <p className="error-message">❌ {error}</p>
        </div>
      </div>
    );
  }

  if (!result) return null;

  return (
    <div className="result-display">
      <div className="result-card">
        <div className="dish-icon">🍽️</div>
        <h2 className="dish-name">{result.name}</h2>
        {result.description && (
          <p className="dish-description">{result.description}</p>
        )}
        {result.category && (
          <span className="dish-category">{result.category}</span>
        )}
      </div>
    </div>
  );
}

export default ResultDisplay;
