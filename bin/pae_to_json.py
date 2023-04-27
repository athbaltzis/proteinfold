#!/usr/bin/env python3

import json
import pickle
import numpy as np

def get_pae_json(pae: np.ndarray, max_pae: float) -> str:
	"""Returns the PAE in the same format as is used in the AFDB.
	Note that the values are presented as floats to 1 decimal place,
	whereas AFDB returns integer values.
	Args:
	pae: The n_res x n_res PAE array.
	max_pae: The maximum possible PAE value.
	Returns:
	PAE output format as a JSON string.
	"""
	# Check the PAE array is the correct shape.
	if (pae.ndim != 2 or pae.shape[0] != pae.shape[1]):
		raise ValueError(f'PAE must be a square matrix, got {pae.shape}')

	# Round the predicted aligned errors to 1 decimal place.
	rounded_errors = np.round(pae.astype(np.float64), decimals=1)
	formatted_output = [{
		'predicted_aligned_error': rounded_errors.tolist(),
		'max_predicted_aligned_error': max_pae
	}]
	return json.dumps(formatted_output, indent=None, separators=(',', ':'))

def main():
	for x in range(1,6):
		input_file = 'result_model_' + str(x) + '_ptm_pred_0.pkl'
		output_file = 'result_model_' + str(x) + '_ptm_predicted_aligned_error_0.json'
		with open(input_file, 'rb') as f:
			data = pickle.load(f)
		pae = data['predicted_aligned_error']
		max_pae = data['max_predicted_aligned_error']
		json_format = get_pae_json(pae, max_pae.tolist())
		with open(output_file, 'w') as f:
			print(json_format, file=f)

if __name__ == "__main__":
    main()
