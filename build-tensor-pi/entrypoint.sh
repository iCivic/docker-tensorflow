#!/usr/bin/env bash
# Copyright 2015 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

echo "启动深度学习研发环境"
# 后台执行【推荐】
# jupyter notebook "$@"
echo "Run jupyter lab"
jupyter lab  "$@" --ip=0.0.0.0 --port=8888 > $HOME/jupyter_notebook.log 2>&1 &

# Tensorboard
echo "Run tensorboard"
# https://github.com/tensorflow/tensorboard
tensorboard --logdir='/tmp/tensorflow_logs' --bind_all --port=6006 > $HOME/tensorboard.log 2>&1 &

# To keep running until the both are terminated
wait
echo "退出"