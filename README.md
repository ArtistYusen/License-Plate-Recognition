# License-Plate-Recognition

AU335 Course Project: license plate recognition using a traditional computer vision based approach.

## Structure

- [`code/`](./code/)
  - [`templates/`](./code/templates/): Templates characters images set.
  - [`solution.m`](./code/solution.m): Top-level recognition code (you can run it directly to get recognition results).
  - [`recognize.m`](./code/recognize.m): Tool function (recognize well-located license plates).
  - [`recoEasy.m`](./code/recoEasy.m): Easy level code.
  - [`recoMedium.m`](./code/recoMedium.m): Medium level code.
  - [`recoDifficult.m`](./code/recoDifficult.m): Difficult level code.
  - [`evaluation.m`](./code/evaluation.m): Evaluation code.
- [`images/`](./images/)
  - [`easy/`](./images/easy/): Easy level images.
  - [`medium/`](./images/medium/): Medium level images.
  - [`difficult/`](./images/difficult/): Difficult level images.
- [`reslut/`](./result/): Recognition results.
- [`article/`](./article/): Thesis pdf files and illustrations.

## Usage

You can directly run the [solution.m](./code/solution.m) file to get recognition results. Or you can use these functions individually.

### Codes

#### Easy level

```matlab
% Run the code to get recognition results.
licenseNumber = recoEasy(path,Name,Value)
```

#### Medium level

```matlab
% Run the code to get recognition results.
licenseNumber = recoMedium(path,task_id,Name,Value)
```

#### Difficult level

```matlab
% Run the code to get recognition results.
licenseNumber = recoDifficult(path,task_id,Name,Value)
```

### Arguments

#### Input

- **path**: path to the image (by default they are in the images folder)
  - _type_: string
  - _example_: `"./images/easy/1.jpg"`
- **task_id**: task id (which image to recognize)
  - _type_: integer (only 1,2,3 are valid)
  - _example_: `1` (2-1.jpg or 3-1.jpg)
- **name-value pair**
  - **WhiteCountPerColumnThreshold**: threshold for character segmentation in the [recognition.m](./code/recognize.m) function (_default: 5_)
    - _type_: double
    - _example_: `"WhiteCountPerColumnThreshold",3`
    - _note_: you can change it as you want, but I'm _not sure_ whether it will work properly :D.
  - **verbose**: whether to print out the detailed results (_default: true_)
    - _type_: logical
    - _example_: `"verbose",false`

#### Output

- **licenseNumber**: recognized license number
  - _type_: string
  - _example_: `"沪EWM957"`
  - _note_: a recognition image will also be output.

## References

- [License Plate Recognition with MATLAB – Angora Tutor](https://angoratutor.com/license-plate-recognition-with-matlab)
- [ThreeSRR/License-Plate-Recogonition: Course Project of AU335-Computer-Vision@SJTU. (github.com)](https://github.com/ThreeSRR/License-Plate-Recogonition)
