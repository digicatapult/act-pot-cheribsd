#shellcheck shell=bash

Describe 'check-pots.sh'
  pot() { return 0; }
  Include ./check-pots.sh
  prepare() { pot='test'; }
  Before 'prepare'

  Describe 'check_tree()'
    It 'Does not output a warning if the given tree exists'
      tree_name='some_tree'
      mkdir $tree_name
      When call check_tree $tree_name
      The output should not include 'was not found'
      rm -fr $tree_name
    End

    It 'Outputs a warning if the given tree does not exist'
      tree_name='some_tree'
      When call check_tree $tree_name
      The output should include 'was not found'
    End

    It 'Outputs a debug message if the given tree is empty'
      tree_name='some_tree'
      mkdir $tree_name
      When call check_tree 'some_tree'
      The output should include 'is empty'
      rm -fr $tree_name
    End

    It 'Has no output if the tree is populated'
      tree_name='some_tree'
      mkdir $tree_name
      touch ${tree_name}/abc
      When call check_tree 'some_tree'
      The output should be blank
      rm -fr $tree_name
    End
  End
End
